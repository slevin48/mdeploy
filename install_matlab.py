from matlab_runtime import install, guess_prefix

version = "R2024b"
install(version,prefix="/workspaces/mdeploy", auto_answer=True)

print(guess_prefix())