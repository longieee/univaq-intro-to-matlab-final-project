function audio_plot(sound_list)
    %AUDIO_PLOT Takes in a list of audio files and plots their waveforms
    % This function is intended to plot the waveforms before and after transformations
    % written inside the rest of the script.
    % The "audios" are essentially vectors of the first channel of the audio
    % data. The function takes in a list of audio files or just a single vector, reads them, and
    % plots their waveforms.
    %   Inputs:
    %       sound_list - A cell array of strings, each string is a path to an audio file
    %   Outputs:
    %       None, but the function will display the waveforms of the audio files
    %   Example usage:
    %       audio_plot({vector1, vector2, vector3});

    % Check if the cell array is empty
    if isempty(sound_list)
        error('audio_plot:InvalidInput', 'Input cell array is empty.');
    end

    % If the input is just a string, convert it to a cell array
    if ischar(sound_list)
        sound_list = {sound_list};
    end
    % Check if the input is a cell array
    if ~iscell(sound_list)
        error('audio_plot:InvalidInput', 'Input must be a cell array of audio file paths.');
    end
    % Initialize an empty cell array to hold the audio data
    audio_data = cell(length(sound_list), 1);
    % Loop through each audio file in the list
    for i = 1:length(sound_list)
        % Read the audio file
        [audio_data{i}, fs] = audioread(sound_list{i});
        % Check if the audio file has more than one channel
        if size(audio_data{i}, 2) > 1
            % Take only the first channel
            audio_data{i} = audio_data{i}(:, 1);
        end
        % Normalize the audio data to the range [-1, 1]
        audio_data{i} = audio_data{i} / max(abs(audio_data{i}));
    end
    % Create a figure for the plots
    figure('Name', 'Audio Waveforms', 'NumberTitle', 'off');
    % Loop through each audio file and plot its waveform
    for i = 1:length(audio_data)
        % Create a subplot for each audio file
        subplot(length(audio_data), 1, i);
        % Plot the waveform
        plot(audio_data{i});
        % Set the title and labels
        title(['Audio File: ', sound_list{i}]);
        xlabel('Sample Number');
        ylabel('Amplitude');
        % Set the x-axis limits
        xlim([0, length(audio_data{i})]);
    end
    % Adjust the layout of the subplots
    sgtitle('Audio Waveforms');
    % Set the figure to be visible
    set(gcf, 'Visible', 'on');
    % Display the file names and sample rates
    for i = 1:length(sound_list)
        [~, file_name, ext] = fileparts(sound_list{i});
        disp(['File Name: ', file_name, ext]);
        disp(['Sample Rate: ', num2str(fs)]);
        % Display the duration of the audio
        duration = length(audio_data{i}) / fs;
        disp(['Duration: ', num2str(duration), ' seconds']);
    end
    % Set the figure to be visible
    set(gcf, 'Visible', 'on');
end