classdef test_read_audio < matlab.unittest.TestCase
    % TEST_READ_AUDIO Unit tests for the function `read_audio.m`.
    %
    % This test suite verifies the correctness of the function `read_audio` 
    % using the MATLAB Unit Testing Framework.
    
    properties
        TestFile
        TempDir
    end
    
    methods(TestMethodSetup)
        function createTestFile(testCase)
            % Create a temporary directory and synthetic audio file for testing
            testCase.TempDir = tempname;
            mkdir(testCase.TempDir);
            
            % Create a simple sine wave audio signal
            fs = 44100;  % Sample rate
            t = 0:1/fs:2;  % 2 seconds
            y = sin(2*pi*440*t)';  % 440 Hz sine wave
            stereo_y = [y, y*0.5];  % Create stereo by duplicating with lower volume
            
            % Save as a temporary WAV file
            testCase.TestFile = fullfile(testCase.TempDir, 'sample.wav');
            audiowrite(testCase.TestFile, stereo_y, fs);
        end
    end

    methods(TestMethodTeardown)
        function cleanupTestFile(testCase)
            % Clean up temporary files
            if exist(testCase.TestFile, 'file')
                delete(testCase.TestFile);
            end
            if exist(testCase.TempDir, 'dir')
                rmdir(testCase.TempDir, 's');
            end
        end
    end
    
    methods(Test)
        function testBasicReading(testCase)
            % Test basic reading functionality
            channel1 = read_audio(testCase.TestFile);
            testCase.verifyTrue(isvector(channel1), 'Output should be a vector');
            testCase.verifyGreaterThan(length(channel1), 0, 'Output should have data');
        end
        
        function testRangeReading(testCase)
            % Test reading with sample range
            start = 100;
            stop = 500;
            channel1 = read_audio(testCase.TestFile, start, stop);
            testCase.verifyEqual(length(channel1), stop-start+1, 'Output length should match specified range');
        end
        
        function testNormalization(testCase)
            % Test normalization option
            channel1 = read_audio(testCase.TestFile, 1, 1000, true);
            testCase.verifyLessThanOrEqual(max(abs(channel1)), 1.0, 'Normalized audio should be within [-1,1]');
            
            % Check if it's actually normalized to max amplitude
            if ~isempty(channel1) && any(abs(channel1) > 0)
                testCase.verifyEqual(max(abs(channel1)), 1.0, 'Output should be normalized to exactly 1.0');
            end
        end
        
        function testDefaultArguments(testCase)
            % Test default arguments
            % Full file reading
            full_channel = read_audio(testCase.TestFile);
            
            % With explicit defaults
            info = audioinfo(testCase.TestFile);
            channel_with_defaults = read_audio(testCase.TestFile, 1, info.TotalSamples, false);
            
            testCase.verifyEqual(full_channel, channel_with_defaults, 'Default arguments should produce same result');
        end
        
        function testTimeBasedInput(testCase)
            % Test time-based input (seconds)
            info = audioinfo(testCase.TestFile);
            fs = info.SampleRate;
            
            % Test with start time in seconds
            time_start = 0.5; % 0.5 seconds
            sample_start = round(time_start * fs);
            
            % Define a duration in samples and calculate equivalent time
            sample_duration = 1000; 
            time_duration = sample_duration / fs;
            
            % First call with time parameters
            channel1 = read_audio(testCase.TestFile, time_start, time_start + time_duration);
            
            % Second call with equivalent sample parameters
            channel2 = read_audio(testCase.TestFile, sample_start, sample_start + sample_duration);
            
            testCase.verifyEqual(channel1, channel2, 'Time-based start should convert correctly to samples');
        end
        
        function testChannelExtraction(testCase)
            % Test that only first channel is returned
            % Our test file is stereo - first channel is sin(2*pi*440*t) at full volume
            [audio_data, ~] = audioread(testCase.TestFile, [1, 1000]);
            expected_channel1 = audio_data(:, 1);
            
            % Compare with read_audio output
            actual_channel1 = read_audio(testCase.TestFile, 1, 1000);
            
            testCase.verifyEqual(actual_channel1, expected_channel1, 'First channel should be extracted correctly');
        end
    end
end