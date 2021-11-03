# kaldi-arabic

This is an experiment to build HHM-based Arabic ASR using Kaldi engine (https://github.com/kaldi-asr/kaldi).

I modified gale_arabic recipe to run it on Common Voice Corpus 7.0 (https://commonvoice.mozilla.org/en/datasets). In this version, Arabic voices are 1,052 and the total length is 117 hours. However, the system is trained on just 30 hours and tested on 12 hours. 

Training on a workstation (CPU: Intel 3.5 GHz, GPU: RTX 2080 Ti) took 9 hours. The DNN-HMM based model reached 29% WER.

You can download the model from here (136 MB):

https://drive.google.com/file/d/1PPpZ47G37YvErhBJtBoi0_v1MawNQ-u8/view?usp=sharing

## Testing
```
# How to run the ASR system in a Docker container

# Download common_voice-v7.0-ar.zip
unzip common_voice-v7.0-ar.zip
# Create kaldiasr container
docker run -it --rm -v <path to common_voice-v7.0-ar>:/opt/kaldi/egs/asr/cv kaldiasr/kaldi:latest bash
# Inside the container run these commands
cd egs/asr/cv
ln -s ../../wsj/s5/utils/ utils
ln -s ../../wsj/s5/steps/ steps
# Test the system
./decode.sh file.wav output.txt
```
## Training

I modified gale_arabic recipe to run it on Common Voice Corpus 7.0 (https://github.com/kaldi-asr/kaldi/tree/master/egs/gale_arabic). Have a the training script (run.sh) and its output (log). 

## Results
```
%WER 58.96 [ 30985 / 52552, 1563 ins, 5970 del, 23452 sub ] exp/tri1/decode/wer_13_0.0
%WER 54.95 [ 28878 / 52552, 1298 ins, 5950 del, 21630 sub ] exp/tri2b/decode/wer_16_0.0
%WER 29.67 [ 15591 / 52552, 642 ins, 2574 del, 12375 sub ] exp/chain/tdnn_1a_sp/decode_test/wer_14_0.0
```
