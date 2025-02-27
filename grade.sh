set -e
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests


contains= $false
for file in `find student-submission`
do
  if [[ -f $file ]] && [[ $file == ListExamples.java ]]
  then
    $contains= $true
  fi
done

if [[ $contains == $true ]]
then
  cp student-submission/ListExamples.java grading-area/
else
  echo "File not found."
  exit 1
fi

cp TestListExamples.java grading-area
cp -r ./lib grading-area
cd grading-area

set +e

# javac grading-area/ListExamples.java >grading-area/errors1.txt 2>&1
# if [[ $? -ne 0 ]]
# then
#   echo "Student File not compiled."
#   exit 2
# fi

javac -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" ListExamples.java TestListExamples.java > errors1.txt 2>&1
if [[ $? -ne 0 ]]
then
  echo "Student File not compiled."
  cat errors1.txt
  exit 2
fi

java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > errors2.txt 2>&1
if [[ $? -ne 0 ]]
then
  echo "File has errors"
  cat errors2.txt
  exit 2
fi


