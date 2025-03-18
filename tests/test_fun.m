classdef test_fun < matlab.unittest.TestCase
    % TEST_FUN Unit tests for the function `fun.m`.
    %
    % This test suite verifies the correctness of the function `fun` using
    % the MATLAB Unit Testing Framework.

    properties (TestParameter)
        % Define test parameters for vector inputs
        u = { [1, 3, 5], [1; 3; 5], [1, 3, 5], [1; 3; 5], [], [5] };
        v = { [2, 2, 6], [2; 2; 6], [2, 2], [2; 2], [1, 2, 3], [10] };
        method = { "truncate", "fill" };
    end

    methods (Test)
        function testEqualLengthVectors(testCase)
            % Test case where vectors have the same length
            u = [1, 3, 5];
            v = [2, 2, 6];
            expected = [2, 3, 6];
            actual = fun(u, v);
            testCase.verifyEqual(actual, expected);
        end

        function testEqualLengthColumnVectors(testCase)
            % Test case for equal-length column vectors
            u = [1; 3; 5];
            v = [2; 2; 6];
            expected = [2; 3; 6];
            actual = fun(u, v);
            testCase.verifyEqual(actual, expected);
        end

        function testTruncateMode(testCase)
            % Test truncate mode with different length vectors
            u = [1, 3, 5];
            v = [2, 2];
            expected = [2, 3];
            actual = fun(u, v, "truncate");
            testCase.verifyEqual(actual, expected);
        end

        function testFillMode(testCase)
            % Test fill mode with different length vectors
            u = [1, 3, 5];
            v = [2, 2];
            expected = [2, 3, 5]; % Missing parts filled with zero
            actual = fun(u, v, "fill");
            testCase.verifyEqual(actual, expected);
        end

        function testFillModeColumnVectors(testCase)
            % Test fill mode with column vectors
            u = [1; 3; 5];
            v = [2; 2];
            expected = [2; 3; 5];
            actual = fun(u, v, "fill");
            testCase.verifyEqual(actual, expected);
        end

        function testInvalidInputNonVector(testCase)
            % Test for non-vector input, should throw an error
            testCase.verifyError(@() fun([1 2; 3 4], [5 6]), 'MATLAB:InputMustBeVector');
        end

        function testInvalidMethodArgument(testCase)
            % Test for invalid method argument, should throw an error
            testCase.verifyError(@() fun([1, 2, 3], [4, 5, 6], "wrong_method"), 'MATLAB:InvalidMethod');
        end

        function testSingleElementVectors(testCase)
            % Test case with single-element vectors
            u = [5];
            v = [10];
            expected = [10];
            actual = fun(u, v);
            testCase.verifyEqual(actual, expected);
        end

        function testEmptyVectorFillMode(testCase)
            % Test empty vector with fill mode
            u = [];
            v = [1, 2, 3];
            expected = [1, 2, 3]; % u is extended with zeros
            actual = fun(u, v, "fill");
            testCase.verifyEqual(actual, expected);
        end
    end
end
