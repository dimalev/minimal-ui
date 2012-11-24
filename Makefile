# MXMLC=mxmlc
MXMLC=./bin/fcsh.py

NAME=minimal-ui
CAMEL_NAME=MinimalUI

SRC_DIR:=src
APP_NAME:=TMain.as

APP_WIDTH:=640
APP_HEIGHT:=480

BG_COLOR:=0xffffff

DEST_DIR:=dest
DEST_NAME:=${NAME}.swf

DEBUG:=true

.PHONY: clean

all: ${DEST_DIR}/${DEST_NAME}

${DEST_DIR}/${DEST_NAME}: ${SRC_DIR}/${APP_NAME} Makefile
	${MXMLC} -source-path ${SRC_DIR} \
           --output ${DEST_DIR}/${DEST_NAME} \
           --default-size ${APP_WIDTH} ${APP_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --debug=${DEBUG} \
           ${SRC_DIR}/${APP_NAME}

clean:
	rm ${DEST_DIR}/${DEST_NAME}
