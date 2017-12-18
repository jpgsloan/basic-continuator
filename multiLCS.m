function [mlcs, maxLength] = multiLCS( s, varargin )
% MULTILCS
%
% Finds the longest common subsequence for multiple sequences
% 
%   SYNTAX     
%       [mlcs, maxLength]  = multiLCS(s)
%
%   INPUT  
%       s: Nx1 cells of mlcs where N is number of sequences 
%          {'gattaca';'gatagcata';'gataca'}
%   
%   OUTPUT 
%       mlcs: Mx1 cells of the longest common subsequences
%       maxLength: |MLCS|
%
% More information about method:
% [1] Chen, Yixin, Andrew Wan, and Wei Liu. "A fast parallel algorithm for 
% finding the longest common sequence of multiple biosequences."
% BMC bioinformatics 7.Suppl 4 (2006): S4.
%
% Copyright: Michal Vozda, michal.vozda@google.com, 2014-
%

%% Test inputs 
%
switch nargin
    case 1
        distOnly = 0;
    case 2
        if all(varargin{1} == 'dist');
            distOnly = 1;
        else
            distOnly = 0;
        end
    otherwise
       error('Unexpected inputs')
end

%% Reduction of data
% Characters which are not included in all sequences are deleted. Returns 
% only unique sequences.
[sRed, Dim, sizeSeq] = reduceAlphabet( s );

%% Test of input data
% Only one unique sequence will return as a mlcs.
if Dim == 1
   mlcs = {char( sRed( sRed ~= 0 ) )};
   maxLength = sizeSeq;
   return
end

%% Initialisation
%
alphabet = unique( sRed(sRed ~= 0 ),'sorted');
alphabetLen = length( alphabet );

%% Sucessor table desing
% This table allows effective solution of mlcs problem. More details in [1].
T = zeros( alphabetLen, max( sizeSeq ) + 1, Dim );

% Find all the initial character pairs.
for i = 1 : alphabetLen  
    for j = 1 : Dim              
        T(i,1,j) = find( sRed( j, : ) == alphabet( i ), 1, 'first' );
    end   
end

% Computation of another levels. 
for i = 1 : Dim
    for j = 2 : max( sizeSeq ) + 1
        for k = 1 : alphabetLen
        
            if sRed( i, j-1 ) == alphabet( k )  
              indNew = j - 1 + find( sRed( i, j : end ) == alphabet( k ), 1, 'first' );
              
              if ~isempty( indNew )
                 T(k,j,i) = indNew;
              else
                 T(k,j,i) = nan; 
              end 
              
            else
               T(k,j,i) = T( k, j-1, i );    
            end
            
        end
    end
end
% Indexing from 1
T = T + 1;

%% Table of tuples in levels
% 
indBuff = [];
levelBuff = [];
indNew = ones( Dim, 1 );
n = 0;

while ~isempty( indNew )   
          
    n = n + 1;
    for i = 1 : size( indNew, 2 )

        for k = 1 : Dim 
            indBuff = [ indBuff, T( :, indNew( k, i ), k ) ];
        end
       

    indBuff( sum( isnan( indBuff ), 2 ) > 0, : ) = [];
    indBuff = indBuff';
    buff = [ indBuff; bsxfun( @times, ones( size( indBuff ) ), indNew( :, i ) ) ];

    levelBuff = [ levelBuff, buff ];
    indBuff = [];
    buff = [];

    end  
    
    indNew = unique( levelBuff( 1 : Dim, : )', 'rows' )';
    levelFin{n} = levelBuff;
    levelBuff = [];    
    
end
Dist = n - 1;

%% Return |mlcs|
% If it is not needed returns only distance else, computes mlcs.
if distOnly  
    mlcs = '';
    maxLength = Dist;
    return    
end

%%
%                       This might be improved
%
%% Pruning rules
% Pruning rules allow delete some sucessors on the same level, more in [1].
for i = 1 : Dist
   
   % Use current sucessors on level i
   buff = unique( levelFin{i}', 'rows' )';
   indSucess = buff( 1 : Dim, : )'; % Sucessors
   indPrecess = buff( Dim+1 : end, : )'; % Precessors
   
   % By sorting find the lowest sucessor, indSucess( 1, : ) is the lowest sucessor
   [~,indSort] = sort( sum( indSucess, 2 ), 'ascend' );
   indSucess = indSucess( indSort, : );
   indPrecess = indPrecess( indSort, : );
   [~,indSort] = sort( max( indSucess' ), 'ascend' );
   indSucess = indSucess( indSort, : );
   indPrecess = indPrecess( indSort, : );
   
   % Initialisation of the table of the pairs sucessors and precessors.
   indFin = [ indSucess( 1, : )'; indPrecess( 1, : )' ];  
   n = 2;
   
   % Delete succesors folowing pruning rules [1].
   for j = 2 : length( indSort )
       if all( indSucess( 1, : ) < indSucess( j, : ) ) | ...
        ( any(indSucess( 1, : ) == indSucess( j, : ) ) & ...
          any(indSucess( 1, : ) < indSucess( j, : ) ) )      
       else    
           indFin(:,n) =  [indSucess(j,:)'; indPrecess(j,:)'];
           n = n+1;           
       end       
   end
  
   succesors{i} = indFin;
   
end

%% Reconstruction
% Finds pathway in sucessors which corresponds with ordinates of MLCS in
% strings
global succesorsG DimG
succesorsG = succesors;
DimG = Dim;

succ = succesors{end};
precFin = [];
n = 1;
for i = 1 : size(succ,2)
   
    precBuff = recon( Dist, succ( Dim + 1 : end, i ) ); % Recursive algorithm
   
    precBuff = [succ( 1, i )*ones(size(precBuff,1),1) ...
                succ( Dim + 1, i )*ones(size(precBuff,1),1) precBuff ];

    for j = 1 : size(precBuff,1)  
      if length( precBuff(j,:) ) - 1 == Dist
          precFin(:,:,n) =   precBuff(j,:)';
          n = n+1; 
      end
    end       

end

%% MLCS recontruction
%
if isempty(precFin)    

    mlcs = '';
    maxLength = 0;
    return
end


mlcsBuff = sRed( 1, : );
for i = 1 : size(precFin,3)
   
   D = ( precFin( :, 1, i ) -1 );
   mlcs{i,:} = fliplr( char( mlcsBuff( D( D ~= 0 ) ) ) );
   
end

maxLength = Dist;

end

function [sRed, Dim, sizeSeq] = reduceAlphabet( s )

Dim = size( s, 1 );
[~,sizeSeq] = cellfun( @size, s );
maxLen = max( sizeSeq );
sBuff = zeros( Dim, maxLen );

for i = 1 : Dim   
    sBuff( i, : ) = [ s{i} zeros( 1, maxLen - sizeSeq( i ) ) ];   
end

for i = 1 : Dim
    Abuff = unique( sBuff( i, : ) );
    Abuff = Abuff( Abuff ~= 0 );
    A( i, 1 : size( Abuff, 2 ) ) = Abuff; 
end

histvect = unique( A );
histvect( histvect == 0 ) = [];
A = A( A(:) ~= 0 );
[h, nbins] = hist( A, [histvect] );
hmax = max( h(:) );
vect = nbins( h ~= hmax );

for i = 1:length( vect )
    sBuff( sBuff == vect( i ) ) = 0; 
end

sRed = zeros( size( sBuff ) );
maxLenBuff = 1;

for i = 1:Dim     
    buff = sBuff( i, : ); 
    buff( buff == 0 ) = [];
    buffLen(i) = length( buff );
    sRed(i,:) = [ buff, zeros( 1, maxLen - buffLen( i ) ) ];     
end

 maxLength = max( buffLen );
 sRed = sRed( :, 1 : maxLen );
 sRed = unique( sRed, 'rows' );

 Dim = size( sRed, 1 );
 sizeSeq = sum( sRed ~= 0, 2 )';
     
end

function precFin = recon( level, succ )
   
global succesorsG DimG

n = 1;
if all( succ >  ones( DimG, 1 ) )
    
    prec = succesorsG{level-1};
       
        for i = 1 : size(prec,2)
           
            if all( succ == prec( 1 : DimG, i ) )
               
                try
                    precBuff = recon( level - 1, prec( DimG + 1 : end, i ) );
                catch
                    level
                end

                sizBuff = size(precBuff,1);
                
                if sizBuff > 1 || n > 1
                    
                    if ~exist( 'precFin' )
                        precFin(n:n+sizBuff-1,:) = [ prec( DimG + 1, i )*ones(sizBuff,1) precBuff ];
                        n = n + sizBuff; 
                        
                    elseif size( precBuff, 2 ) == (size( precFin, 2 ) - 1)
                    
                        precFin(n:n+sizBuff-1,:) = [ prec( DimG + 1, i )*ones(sizBuff,1) precBuff ];
                        n = n + sizBuff;
                    
                    end
                    
                else
                    precFin = [ prec( DimG + 1, i ) precBuff ];
                    n = n + 1;
                end
            end          
            
        end

else
    
  precFin = []; 
  
end  
if ~exist('precFin')
   precFin = []; 
end
end