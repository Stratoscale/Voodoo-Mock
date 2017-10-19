#!/bin/bash
SUITE=$1
TEST_LINE=$2

function isPython {
    echo $SUITE | grep '\.py$' > /dev/null
}
function isCxxTest {
    echo $SUITE | grep 'Test_.*\.[hH].\?.\?$' > /dev/null
}

if isPython $SUITE; then
    TEST_NAME=`python $VOODOO_ROOT_DIR/pytest/findtestnamefromlinenumber.py $SUITE $TEST_LINE`
	python $VOODOO_ROOT_DIR/pytest/pytestrunner.py --verbose --singleTest=$TEST_NAME $SUITE
else
    if [ ! isCxxTest ]; then
        echo "$SUITE was not recognized as niether python test suite or CxxTest suite files"
        exit 1
    fi
    TEST_NAME=`python $VOODOO_ROOT_DIR/pytest/findtestnamefromlinenumber.py $SUITE $TEST_LINE`
    NO_EXT=`echo $SUITE | sed 's@\.[hH].\?.\?$@@'`
    NO_EXT_UNDERSCORE=`echo $NO_EXT | sed 's@/@_@g'`
    BIN=build_unittest/${NO_EXT_UNDERSCORE}.bin
    LC_ALL=C $BIN $TEST_NAME
fi
