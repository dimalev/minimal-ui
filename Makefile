# MXMLC=mxmlc
MXMLC=./bin/fcsh.py
COMPC=compc

NAME=minimal-ui
CAMEL_NAME=MinimalUI

SRC_DIR:=src
APP_NAME:=Main.as

APP_WIDTH:=800
APP_HEIGHT:=600

BG_COLOR:=0xffffff

DEST_DIR:=dest
DEST_NAME:=${NAME}.swf
DEST_LIB_NAME:=${NAME}.swc

TEST_LIBS:=lib/flexunit-uilistener.swc:lib/flexunit4.swc

TEST_DIR:=test

TEST_APP_NAME:=TestRunner.mxml
TEST_RUNNER_SRC:=${TEST_DIR}/TestSuite.as
TEST_CASES_SRC:=${TEST_DIR}/cases/*.as
TEST_APP:=test.swf

TEST_WIDTH:=1024
TEST_HEIGHT:=800

DEBUG:=true

.PHONY: clean

all: app test

app: ${DEST_DIR}/${DEST_NAME}

lib: ${DEST_DIR}/${DEST_LIB_NAME}

test: ${DEST_DIR}/${TEST_APP}

${DEST_DIR}/${DEST_NAME}: ${SRC_DIR}/${APP_NAME} Makefile
	${MXMLC} -source-path ${SRC_DIR} \
           --output ${DEST_DIR}/${DEST_NAME} \
           --default-size ${APP_WIDTH} ${APP_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --debug=${DEBUG} \
           ${SRC_DIR}/${APP_NAME}

${DEST_DIR}/${DEST_LIB_NAME}: ${SRC_DIR}/${APP_NAME} Makefile
	${COMPC} -source-path ${SRC_DIR} \
           -include-sources ${SRC_DIR}/com/minimalui/ \
           --output ${DEST_DIR}/${DEST_LIB_NAME}

${DEST_DIR}/${TEST_APP}: ${TEST_DIR}/${TEST_APP_NAME} ${TEST_RUNNER_SRC} ${TEST_CASES_SRC}
	${MXMLC} -source-path ${SRC_DIR} ${CLASSPATH_DIR} \
           --output ${DEST_DIR}/${TEST_APP} \
           --default-size ${TEST_WIDTH} ${TEST_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --debug=${DEBUG} \
           --library-path+=${TEST_LIBS}:${APP_LIBS} \
           ${TEST_DIR}/${TEST_APP_NAME}

docs:
	asdoc -source-path ${SRC_DIR} -doc-sources ${SRC_DIR} -exclude-sources src/com/minimalui/containers/Box.as -output docs/

clean:
	-rm ${DEST_DIR}/${DEST_NAME}
	-rm ${DEST_DIR}/${TEST_APP}
