% Add submodule paths
addpath('utils');
addpath('static');

audio1 = read_audio("static/clair-de-lune.mp3", 33, 33.3, false);
audio2 = read_audio("static/moonlight-sonata.mp3", 33, 33.3, false);

blended_audio = fun(audio1, audio2, "truncate");

sound_list = {audio1, audio2, blended_audio};

audio_plot(sound_list);