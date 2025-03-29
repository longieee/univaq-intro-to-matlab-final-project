function channel1 = read_audio(file_path, start, stop, normalize)
    %READ_AUDIO Read an MP3 file and return the first channel
    %   channel1 = read_audio(file_path, start, stop, normalize) reads the MP3 file specified
    %   by file_path from the start sample to the stop sample and returns the first channel.
    %   If normalize is true, the audio data is normalized to the range [-1, 1].
    %   
    %   Inputs:
    %       file_path - Path to the MP3 file
    %       start - Optional start sample (default: 1)
    %       stop - Optional stop sample (default: end of file)
    %       normalize - Optional boolean to indicate if normalization is needed (default: false)
    %   Outputs:
    %       channel1 - First channel of the audio data
    %   Example usage:
    %       channel1 = read_audio('path/to/audio.mp3', 1000, 5000, true);

    % Handle optional arguments
    if nargin < 2 || isempty(start)
        start = 1;
    end
    
    if nargin < 3 || isempty(stop)
        info = audioinfo(file_path);
        stop = info.TotalSamples;
    end
    
    if nargin < 4
        normalize = false;
    end
    
    % Read audio with specified range
    [audio_data, fs] = audioread(file_path, [start, stop]);
    channel1 = audio_data(:, 1);
    
    if normalize
        % Normalize the audio data to the range [-1, 1]
        channel1 = channel1 / max(abs(channel1));
    end

    % Display the file name
    [~, file_name, ext] = fileparts(file_path);
    disp(['File Name: ', file_name, ext]);
    % Display the number of channels
    num_channels = size(audio_data, 2);
    disp(['Number of Channels: ', num2str(num_channels)]);
    % Display the sample rate
    disp(['Sample Rate: ', num2str(fs)]);
    % Display the duration of the audio
    duration = length(channel1) / fs;
    disp(['Duration: ', num2str(duration), ' seconds']);
    % Display the range read
    disp(['Range: ', num2str(start), ' to ', num2str(stop), ' (', num2str(stop-start+1), ' samples)']);
end
