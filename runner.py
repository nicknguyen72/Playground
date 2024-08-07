import os
import sys
from robot import run

# Define the path to the Robot Framework test suite
robot_test_suite = os.path.join(os.path.dirname(__file__), 'test_suite.robot')

# Run the test suite
result = run(robot_test_suite, outputdir='./results')

# Exit with the appropriate status code
sys.exit(result.return_code)