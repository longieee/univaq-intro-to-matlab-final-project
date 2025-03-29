classdef test_read_audio < matlab.unittest.TestCase
    % TEST_READ_AUDIO Unit tests for the function `read_audio.m`.
    %
    % This test suite verifies the correctness of the function `read_audio` 
    % using the MATLAB Unit Testing Framework.
    
    properties
        % Sample test files
        TestFile = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'test_data', 'sample.mp3');
        % Create a temporary directory for test files if needed
        TempDir
    end
    
    methods(TestMethodSetup)
        function createTempDir(testCase)
            testCase.TempDir = tempdir;
        end
    end
    
    methods(Test)
        function testBasicReading(testCase)
            % Test basic reading functionality
            % This test assumes sample.mp3 exists in the test_data directory
            if exist(testCase.TestFile, 'file')
                channel1 = read_audio(testCase.TestFile);
                testCase.verifyTrue(isvector(channel1), 'Output should be a vector');
                testCase.verifyGreaterThan(length(channel1), 0, 'Output should have data');
            else
                % Skip test if test file doesn't exist
                testCase.assumeFail(['Test file not found: ', testCase.TestFile]);
            end
        end
        
        function testRangeReading(testCase)
            % Test reading with sample range
            if exist(testCase.TestFile, 'file')
                start = 100;
                stop = 500;
                channel1 = read_audio(testCase.TestFile, start, stop);
                testCase.verifyEqual(length(channel1), stop-start+1, 'Output length should match specified range');
            else
                testCase.assumeFail(['Test file not found: ', testCase.TestFile]);
            end
        end
        
        function testNormalization(testCase)
            % Test normalization option
            if exist(testCase.TestFile, 'file')
                channel1 = read_audio(testCase.TestFile, 1, 1000, true);
                testCase.verifyLessThanOrEqual(max(abs(channel1)), 1.0, 'Normalized audio should be within [-1,1]');
                
                % Check if it's actually normalized to max amplitude
                if ~isempty(channel1) && any(abs(channel1) > 0)
                    testCase.verifyEqual(max(abs(channel1)), 1.0, 'Output should be normalized to exactly 1.0');
                end
            else
                testCase.assumeFail(['Test file not found: ', testCase.TestFile]);
            end
        end
        
        function testDefaultArguments(testCase)
            % Test default arguments
            if exist(testCase.TestFile, 'file')
                % Full file reading
                full_channel = read_audio(testCase.TestFile);
                
                % With explicit defaults
                info = audioinfo(testCase.TestFile);
                channel_with_defaults = read_audio(testCase.TestFile, 1, info.TotalSamples, false);
                
                testCase.verifyEqual(full_channel, channel_with_defaults, 'Default arguments should produce same result');
            else
                testCase.assumeFail(['Test file not found: ', testCase.TestFile]);
            end
        end
        
        function testTimeBasedInput(testCase)
            % Test time-based input (seconds)
            if exist(testCase.TestFile, 'file')
                info = audioinfo(testCase.TestFile);
                fs = info.SampleRate;
                
                % Test with start time in seconds (assuming < 1)
                time_start = 0.5; % 0.5 seconds
                sample_start = round(time_start * fs);
                
                channel1 = read_audio(testCase.TestFile, time_start, 1000);
                channel2 = read_audio(testCase.TestFile, sample_start, 1000);
                
                testCase.verifyEqual(channel1, channel2, 'Time-based start should convert correctly to samples');
            else
                testCase.assumeFail(['Test file not found: ', testCase.TestFile]);
            end
        end
        
        function testChannelExtraction(testCase)
            % Test that only first channel is returned
            if exist(testCase.TestFile, 'file')
                info = audioinfo(testCase.TestFile);
                
                if info.NumChannels > 1
                    % Read directly with audioread to get all channels
                    [audio_data, ~] = audioread(testCase.TestFile, [1, 1000]);
                    expected_channel1 = audio_data(:, 1);
                    
                    % Compare with read_audio output
                    actual_channel1 = read_audio(testCase.TestFile, 1, 1000);
                    
                    testCase.verifyEqual(actual_channel1, expected_channel1, 'First channel should be extracted correctly');
                else
                    % Skip test for mono files
                    testCase.assumeEqual(info.NumChannels, 2, 'Test requires stereo file');
                end
            else
                testCase.assumeFail(['Test file not found: ', testCase.TestFile]);
            end
        end
    end
end