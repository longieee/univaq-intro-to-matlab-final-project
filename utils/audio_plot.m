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

    % If the input is just 1 vector, convert it to a cell array
    if isvector(sound_list)
        sound_list = {sound_list};
    end

    % Check if the input is a cell array
    if ~iscell(sound_list)
        error('audio_plot:InvalidInput', 'Input must be a cell array of audio file paths.');
    end
    
    % Determine number of audio files
    num_sounds = numel(sound_list);

    % Create a figure with subplots for each audio file
    figure('Name', 'Audio Waveforms', 'NumberTitle', 'off');

    % Loop through each audio file and plot its waveform
    for i = 1:num_sounds
        subplot(num_sounds, 1, i);
        
        % Get the current audio data
        audio_data = sound_list{i};
        
        % Plot the waveform
        plot(audio_data);
        
        % Add title and labels
        title(['Audio Waveform ' num2str(i)]);
        xlabel('Sample');
        ylabel('Amplitude');
        
        % Add grid for better visualization
        grid on;
    end

    % Adjust the spacing between subplots
    set(gcf, 'Position', [100, 100, 800, 200*num_sounds]);
end