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
        
        function testNormalization(testCase)
            % Test normalization option
            % Using 0-0.1 seconds instead of sample indices
            channel1 = read_audio(testCase.TestFile, 0, 0.1, true);
            testCase.verifyLessThanOrEqual(max(abs(channel1)), 1.0, 'Normalized audio should be within [-1,1]');
            
            % Check if it's actually normalized to max amplitude
            if ~isempty(channel1) && any(abs(channel1) > 0)
                testCase.verifyEqual(max(abs(channel1)), 1.0, 'Output should be normalized to exactly 1.0');
            end
        end
        
        function testDefaultArguments(testCase)
            % Test default arguments
            % Read audio info to get file parameters
            info = audioinfo(testCase.TestFile);
            
            % Full file reading
            full_channel = read_audio(testCase.TestFile);
            
            % With explicit defaults - if the function is supposed to read the entire file
            % when called without end time, there's no need for duration parameter
            channel_with_defaults = read_audio(testCase.TestFile, 0, info.TotalSamples/info.SampleRate, false);
            
            testCase.verifyEqual(size(full_channel), size(channel_with_defaults), 'Output sizes should match');
            testCase.verifyEqual(full_channel, channel_with_defaults, 'Default arguments should produce same result');
        end
        
        function testTimeBasedInput(testCase)
            % Test time-based input
            % Using audioread directly with samples to compare with read_audio using time
            info = audioinfo(testCase.TestFile);
            fs = info.SampleRate;
            
            % Test with specific time range
            time_start = 0.5; % 0.5 seconds
            time_end = 1.0; % 1.0 seconds
            
            % Calculate corresponding sample range
            sample_start = round(time_start * fs);
            sample_end = round(time_end * fs);
            
            % Get audio directly using sample indices with audioread
            [audio_data, ~] = audioread(testCase.TestFile, [sample_start, sample_end]);
            expected_channel1 = audio_data(:, 1);
            
            % Get audio using read_audio with time-based parameters
            actual_channel1 = read_audio(testCase.TestFile, time_start, time_end);
            
            testCase.verifyEqual(actual_channel1, expected_channel1, 'Time-based input should match direct sample access');
        end
        
        function testChannelExtraction(testCase)
            % Test that only first channel is returned
            % Time-based parameters (0 to 0.02 seconds)
            time_start = 0;
            time_end = 0.02;
            fs = audioinfo(testCase.TestFile).SampleRate;
            
            % Calculate sample range
            sample_start = max(1, round(time_start * fs));
            sample_end = round(time_end * fs);
            
            % Get expected first channel directly
            [audio_data, ~] = audioread(testCase.TestFile, [sample_start, sample_end]);
            expected_channel1 = audio_data(:, 1);
            
            % Compare with read_audio output
            actual_channel1 = read_audio(testCase.TestFile, time_start, time_end);
            
            testCase.verifyEqual(actual_channel1, expected_channel1, 'First channel should be extracted correctly');
        end
    end
end