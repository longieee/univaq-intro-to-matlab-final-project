classdef test_extendVectors < matlab.unittest.TestCase
    % TEST_EXTENDVECTORS Unit tests for the function `extendVectors.m`.
    %
    % This test suite verifies the correctness of the function `extendVectors`
    % using the MATLAB Unit Testing Framework.
    
    methods (Test)
        function testRowVectors(testCase)
            % Test with row vectors where first is shorter
            v1 = [1, 2, 3];
            v2 = [4, 5, 6, 7, 8];
            [v1_ext, v2_ext] = extendVectors(v1, v2);
            
            testCase.verifyEqual(length(v1_ext), length(v2_ext), 'Vectors should have equal length');
            testCase.verifyEqual(v1_ext, [1, 2, 3, 0, 0], 'First vector should be padded with zeros');
            testCase.verifyEqual(v2_ext, [4, 5, 6, 7, 8], 'Second vector should remain unchanged');
            testCase.verifyTrue(isrow(v1_ext), 'Extended vector should maintain row orientation');
        end
        
        function testColumnVectors(testCase)
            % Test with column vectors where second is shorter
            v1 = [1; 2; 3; 4];
            v2 = [5; 6];
            [v1_ext, v2_ext] = extendVectors(v1, v2);
            
            testCase.verifyEqual(length(v1_ext), length(v2_ext), 'Vectors should have equal length');
            testCase.verifyEqual(v1_ext, [1; 2; 3; 4], 'First vector should remain unchanged');
            testCase.verifyEqual(v2_ext, [5; 6; 0; 0], 'Second vector should be padded with zeros');
            testCase.verifyTrue(iscolumn(v2_ext), 'Extended vector should maintain column orientation');
        end
        
        function testMixedOrientations(testCase)
            % Test with mixed orientations (row and column)
            v1 = [1, 2, 3];
            v2 = [4; 5; 6; 7];
            [v1_ext, v2_ext] = extendVectors(v1, v2);
            
            testCase.verifyEqual(length(v1_ext), length(v2_ext), 'Vectors should have equal length');
            testCase.verifyTrue(isrow(v1_ext), 'First vector should maintain row orientation');
            testCase.verifyTrue(iscolumn(v2_ext), 'Second vector should maintain column orientation');
        end
        
        function testEqualLengthVectors(testCase)
            % Test with vectors of equal length
            v1 = [1, 2, 3];
            v2 = [4, 5, 6];
            [v1_ext, v2_ext] = extendVectors(v1, v2);
            
            testCase.verifyEqual(v1_ext, v1, 'Equal length vectors should remain unchanged');
            testCase.verifyEqual(v2_ext, v2, 'Equal length vectors should remain unchanged');
        end
        
        function testEmptyVectors(testCase)
            % Test with one empty vector
            v1 = [];
            v2 = [1, 2, 3];
            [v1_ext, v2_ext] = extendVectors(v1, v2);
            
            testCase.verifyEqual(length(v1_ext), length(v2_ext), 'Vectors should have equal length');
            testCase.verifyEqual(v1_ext, [0, 0, 0], 'Empty vector should be filled with zeros');
            testCase.verifyEqual(v2_ext, [1, 2, 3], 'Non-empty vector should remain unchanged');
        end
        
        function testNonVectorInput(testCase)
            % Test with non-vector input, should throw an error
            testCase.verifyError(@() extendVectors([1, 2; 3, 4], [5, 6]), '');
        end
        
        function testSingleElementVectors(testCase)
            % Test with single-element vectors
            v1 = [5];
            v2 = [10];
            [v1_ext, v2_ext] = extendVectors(v1, v2);
            
            testCase.verifyEqual(v1_ext, v1, 'Single-element vectors should remain unchanged');
            testCase.verifyEqual(v2_ext, v2, 'Single-element vectors should remain unchanged');
        end
    end
end