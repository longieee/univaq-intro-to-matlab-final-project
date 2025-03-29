function channel1 = read_audio(file_path, normalize)
    %READ_AUDIO Read an MP3 file and return the first channel
    %   channel1 = read_audio(file_path, normalize) reads the MP3 file specified
    %   by file_path and returns the first channel of the audio data. If
    %   normalize is true, the audio data is normalized to the range [-1, 1].
    %   If normalize is not specified, it defaults to false.
    %   Inputs:
    %       file_path - Path to the MP3 file
    %       normalize - Optional boolean to indicate if normalization is needed
    %   Outputs:
    %       channel1 - First channel of the audio data
    %   Example usage:
    %       channel1 = read_audio('path/to/audio.mp3', true);

    [audio_data, fs] = audioread(file_path);
    channel1 = audio_data(:, 1);
    
    if nargin < 2
        normalize = false;
    end

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
end
