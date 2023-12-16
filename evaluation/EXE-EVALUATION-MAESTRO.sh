#! /bin/bash
CURRENT_DIR=$(pwd)
GOOGLE_DRIVE_DIR=/content/drive/MyDrive

FILE_LIST=$GOOGLE_DRIVE_DIR/MAESTRO-V3/list/$2.list
FILE_CONFIG=$GOOGLE_DRIVE_DIR/MAESTRO-V3/dataset/config.json
DIR_FEATURE=$GOOGLE_DRIVE_DIR/MAESTRO-V3/feature
DIR_REFERENCE=$GOOGLE_DRIVE_DIR/MAESTRO-V3/reference

DIR_CHECKPOINT=$CURRENT_DIR/checkpoint/MAESTRO-V3

DIR_RESULT=$CURRENT_DIR/result/MAESTRO-V3
mkdir -p $DIR_RESULT

MODE=combination
OUTPUT=2nd

# inference
python3 $CURRENT_DIR/evaluation/m_inference.py -f_list $FILE_LIST -f_config $FILE_CONFIG -d_cp $DIR_CHECKPOINT -m $1 -d_fe $DIR_FEATURE -d_mpe $DIR_RESULT -d_note $DIR_RESULT -calc_transcript -mode $MODE &&
# (for half-stride)
#python3 $CURRENT_DIR/evaluation/m_inference.py -f_list $FILE_LIST -f_config $FILE_CONFIG -d_cp $DIR_CHECKPOINT -m $1 -d_fe $DIR_FEATURE -d_mpe $DIR_RESULT -d_note $DIR_RESULT -calc_transcript -mode $MODE  -n_stride 32 &&

# mir_eval
python3 $CURRENT_DIR/evaluation/m_transcription.py -f_list $FILE_LIST -d_ref $DIR_REFERENCE -d_est $DIR_RESULT -d_out $DIR_RESULT -output $OUTPUT &&
python3 $CURRENT_DIR/evaluation/m_transcription.py -f_list $FILE_LIST -d_ref $DIR_REFERENCE -d_est $DIR_RESULT -d_out $DIR_RESULT -output $OUTPUT -velocity &&
python3 $CURRENT_DIR/evaluation/m_mpe.py -f_config $FILE_CONFIG -f_list $FILE_LIST -d_ref $DIR_REFERENCE -d_est $DIR_RESULT -d_out $DIR_RESULT -output $OUTPUT -thred_mpe 0.5
