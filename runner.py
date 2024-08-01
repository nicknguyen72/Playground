import subprocess

def run_robot_tests():
    result = subprocess.run(["robot", "code.robot"], capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)

if __name__ == "__main__":
    run_robot_tests()