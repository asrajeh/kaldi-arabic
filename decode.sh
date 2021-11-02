#!/bin/bash
# written by Abdullah Alrajeh, Nov 2021
# use: ./decode.sh file.wav output.txt

START=$(date +%s)
IN=`pwd`/$1
OUT=`pwd`/$2
nj=1

x=new

. ./path.sh
. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.
echo $IN $OUT
# data preparation
rm -rf data/$x data/${x}_hires $OUT
mkdir -p data/$x
echo $IN "sox "$IN" -r 16000 -t wav -e signed-integer - remix - |" > data/$x/wav.scp
echo $IN $IN > data/$x/spk2utt
echo $IN $IN > data/$x/utt2spk
cat data/$x/utt2spk | awk '{print $1" bla bla"}' > data/$x/text
len=$(soxi -D $IN)
echo $IN $IN 0 $len > data/$x/segments

# feature extraction
utils/copy_data_dir.sh data/$x data/${x}_hires
steps/make_mfcc.sh --nj $nj --mfcc-config conf/mfcc_hires.conf --cmd "$train_cmd" data/${x}_hires
steps/compute_cmvn_stats.sh data/${x}_hires
utils/fix_data_dir.sh data/${x}_hires
steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj "$nj" \
  data/${x}_hires exp/nnet3/extractor exp/nnet3/ivectors_${x}_hires

# decoding
chunk_width=150,110,100
frames_per_chunk=$(echo $chunk_width | cut -d, -f1)
dir=exp/chain/tdnn_1a_sp
tree_dir=exp/chain/tree_a_sp

rm -rf ${dir}/decode_${x}
steps/nnet3/decode.sh \
      --acwt 1.0 --post-decode-acwt 10.0 \
      --extra-left-context 0 --extra-right-context 0 \
      --extra-left-context-initial 0 \
      --extra-right-context-final 0 \
      --frames-per-chunk $frames_per_chunk \
      --nj $nj --cmd "$decode_cmd"  --num-threads 4 \
      --online-ivector-dir exp/nnet3/ivectors_${x}_hires \
      --skip_diagnostics true \
      --scoring_opts "--word_ins_penalty 0.0 --min_lmwt 14 --max_lmwt 14" \
      $tree_dir/graph data/${x}_hires ${dir}/decode_${x} || exit 1

out=$dir/decode_${x}/scoring_kaldi/penalty_0.0
cat ${out}/14.txt | cut -d' ' -f2- | perl bw2ar.pl > $OUT

END=$(date +%s)
DIFF=$(( $END - $START ))
echo Decoding took $DIFF seconds
