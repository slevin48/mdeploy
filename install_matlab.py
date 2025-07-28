from matlab_runtime import install, guess_prefix

version = "R2025a"
install(version,prefix="/workspaces/mdeploy", auto_answer=True)

print(guess_prefix())