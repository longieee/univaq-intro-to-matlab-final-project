classdef test_audio_plot < matlab.unittest.TestCase
    % TEST_AUDIO_PLOT Unit tests for the function `audio_plot.m`.
    %
    % This test suite verifies the correctness of the function `audio_plot` 
    % using the MATLAB Unit Testing Framework.
    
    properties
        % Sample test data
        TestVector1
        TestVector2
        TestVector3
    end
    
    methods(TestMethodSetup)
        function createTestData(testCase)
            % Create sample test vectors for plotting
            testCase.TestVector1 = sin(linspace(0, 2*pi, 100))';
            testCase.TestVector2 = cos(linspace(0, 4*pi, 200))';
            testCase.TestVector3 = 0.5 * sin(linspace(0, 8*pi, 300))';
        end
    end
    
    methods(Test)
        function testSingleVector(testCase)
            % Test with a single vector input
            try
                audio_plot(testCase.TestVector1);
                fig = findobj('Type', 'figure', 'Name', 'Audio Waveforms');
                testCase.verifyEqual(length(fig), 1, 'Should create one figure');
                testCase.verifyEqual(length(findobj(fig, 'Type', 'axes')), 1, 'Should create one subplot');
                close(fig);
            catch e
                close all;
                testCase.verifyFail(['Function failed with error: ', e.message]);
            end
        end
        
        function testMultipleVectors(testCase)
            % Test with multiple vectors in cell array
            try
                audio_plot({testCase.TestVector1, testCase.TestVector2, testCase.TestVector3});
                fig = findobj('Type', 'figure', 'Name', 'Audio Waveforms');
                testCase.verifyEqual(length(fig), 1, 'Should create one figure');
                testCase.verifyEqual(length(findobj(fig, 'Type', 'axes')), 3, 'Should create three subplots');
                close(fig);
            catch e
                close all;
                testCase.verifyFail(['Function failed with error: ', e.message]);
            end
        end
        
        function testEmptyInput(testCase)
            % Test with empty input
            testCase.verifyError(@() audio_plot({}), 'audio_plot:InvalidInput');
        end
        
        function testNonVectorNonCellInput(testCase)
            % Test with non-vector and non-cell input
            testCase.verifyError(@() audio_plot(ones(3,3)), 'audio_plot:InvalidInput');
        end
        
        function testCellWithDifferentSizes(testCase)
            % Test with cell array containing vectors of different sizes
            try
                audio_plot({testCase.TestVector1, testCase.TestVector2});
                fig = findobj('Type', 'figure', 'Name', 'Audio Waveforms');
                testCase.verifyEqual(length(fig), 1, 'Should create one figure');
                testCase.verifyEqual(length(findobj(fig, 'Type', 'axes')), 2, 'Should create two subplots');
                close(fig);
            catch e
                close all;
                testCase.verifyFail(['Function failed with error: ', e.message]);
            end
        end
        
        function testLabelingAndGridding(testCase)
            % Test that labels and grid are applied correctly
            try
                audio_plot({testCase.TestVector1});
                fig = findobj('Type', 'figure', 'Name', 'Audio Waveforms');
                ax = findobj(fig, 'Type', 'axes');
                
                % Check that title exists using the Title property
                testCase.verifyNotEmpty(get(ax, 'Title'), 'Should have a title');
                testCase.verifyNotEmpty(get(ax(1).Title, 'String'), 'Title should have text');
                
                % Check that x-label and y-label exist
                testCase.verifyEqual(length(get(ax, 'XLabel')), 1, 'Should have an x-label');
                testCase.verifyEqual(length(get(ax, 'YLabel')), 1, 'Should have a y-label');
                
                % Check that grid is on
                testCase.verifyTrue(ax.XGrid, 'Grid should be on');
                testCase.verifyTrue(ax.YGrid, 'Grid should be on');
                
                close(fig);
            catch e
                close all;
                testCase.verifyFail(['Function failed with error: ', e.message]);
            end
        end
        
        function testFigureProperties(testCase)
            % Test that figure properties are set correctly
            try
                audio_plot({testCase.TestVector1, testCase.TestVector2});
                fig = findobj('Type', 'figure', 'Name', 'Audio Waveforms');
                pos = get(fig, 'Position');
                
                % Verify figure position includes the expected width and a height
                % proportional to the number of subplots
                testCase.verifyEqual(pos(3), 800, 'Figure width should be 800');
                testCase.verifyEqual(pos(4), 400, 'Figure height should be 200*num_sounds');
                
                close(fig);
            catch e
                close all;
                testCase.verifyFail(['Function failed with error: ', e.message]);
            end
        end
    end
    
    methods(TestMethodTeardown)
        function closeFigures(testCase)
            % Close any open figures after each test
            close all;
        end
    end
end