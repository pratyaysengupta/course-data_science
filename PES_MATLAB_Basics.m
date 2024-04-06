% MATLAB Basics Tutorial

%% General Commands
% Displaying and navigating the workspace
ls        % List contents of the current directory
clc       % Clear the command window
clear     % Clear variables from the workspace
clear all % Clear all variables and functions from the workspace
!explorer . % Open the file explorer in the current directory
pwd       % Display the current working directory

% Help and location
help ls   % Display help for the ls command
loc ls   % Display the location of the ls function

%% Essential Functions
% Matrix manipulation and information
A = zeros(10); % Create a 10x10 matrix of zeros
who            % Display the variables in the workspace
whos           % Display detailed information about variables in the workspace
B = sparse(A); % Convert matrix A to a sparse matrix
save           % Save all variables to a file

% Matrix size and class
sz = size(B);  % Get the size of matrix B
class(sz);     % Display the class of sz
whos sz        % Display detailed information about the variable sz

% Other matrix operations
length(sz)     % Display the length of sz
numel(A)       % Display the number of elements in matrix A

% Random matrix and logical indexing
C = rand(10);         % Create a random 10x10 matrix
C = rand(10) > 0.3;   % Create a logical matrix by thresholding the random matrix
spy(C)                % Display the sparsity pattern of the logical matrix

% Matrix visualization
spy(C + C')           % Display the sparsity pattern of the sum of the logical matrix and its transpose
q = symrcm(B);        % Perform Reverse Cuthill-McKee reordering on matrix B
spy(C(q,q))           % Display the sparsity pattern of the reordered matrix
imagesc(C(q,q))       % Display the image of the reordered matrix

% Vector creation and manipulation
1:7:100         % Create a vector with a step of 7, ending at 100
linspace(1, 99, 15)   % Create a linearly spaced vector with 15 points between 1 and 99
linspace(1, 102, 17)  % Create a linearly spaced vector with 17 points between 1 and 102

% Special matrices
A = hilb(6)     % Create a Hilbert matrix of order 6
format rat      % Change the display format to rational numbers
format compact  % Compact the display format
format long     % Change the display format to long
det(A)          % Calculate the determinant of matrix A

% Vectorization and indexing
A(:)              % Display all elements of matrix A as a column vector
size(A(:))        % Display the size of the column vector
y = (x(:)')       % Transpose the vector x

A(2,:)            % Access the second row of matrix A
A(:,2)            % Access the second column of matrix A
A(:,1:end-1)      % Access all columns except the last one
disp(A)           % Display matrix A

% Manipulating a vector
B = 1:16
B(3:3:end)=0       % Set every third element of B to zero
B(B==0)=-5         % Replace zero elements with -5
B([2:4],[3:4])     % Access a submatrix of B

% Statistical operations
mean(B)            % Calculate the mean of vector B
prod(size(x)) == numel(x)  % Check if the product of size(x) equals the number of elements in x

% Eigenvalues
eig(compan([1 0 0 -1]))  % Calculate the eigenvalues of the companion matrix

% Indexing and manipulation
B(find(B==-5))=0   % Replace the element equal to -5 in B with zero
whos i            % Display information about the variable i
i                % Display the variable i
whos j            % Display information about the variable j
j                % Display the variable j

% Matrix creation
ones(3)           % Create a matrix of ones
ones(3,2)         % Create a matrix of ones with 3 rows and 2 columns
zeros(3,2)        % Create a matrix of zeros with 3 rows and 2 columns
eye(3,4)          % Create a 3x4 identity matrix
rand(4)           % Create a 4x4 matrix of random numbers

% Complex numbers and functions
x = i + j         % Create a complex number x = i + j
f = inline('x^2') % Create an inline function f(x) = x^2
f(3)              % Evaluate the function f at x = 3

% Cell arrays
a = {1}           % Create a cell array with a numeric element
a = {1; 'SysBio'} % Create a cell array with a numeric and string element
a{3} = [1 1; 2 1] % Add a 2x2 matrix to the cell array
cellfun(@length, a) % Use cellfun to apply the length function to each cell element

%% Basic Operations
% Arithmetic operations
2 + 3    % Addition
4 * 5    % Multiplication
10 / 2   % Division

%% Variables
% Variable assignment and arithmetic
a = 5;
b = 7;
c = a + b;

%% Vectors and Matrices
% Vector and matrix creation and indexing
v = [1 2 3 4 5];
M = [1 2 3; 4 5 6; 7 8 9];
v(3)    % Access the third element of the vector
M(2, 1) % Access the element in the second row, first column of the matrix

%% Mathematical Operations
% Mathematical functions
sqrt(25)      % Square root
sin(pi/2)     % Sine function

%% Plotting
% Generating and plotting data
x = linspace(0, 2*pi, 100);
y = sin(x);
plot(x, y);

%% Loops
% For loop example
for i = 1:5
    disp(i);
end