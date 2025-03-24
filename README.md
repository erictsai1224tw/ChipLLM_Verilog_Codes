# Verilog Codes

This project generates advanced hardware design problems suitable for a Verilog programming contest. The problems are designed to push participants to demonstrate in-depth knowledge of digital logic, hardware architecture, timing analysis, and verification skills.


## Files and Directories

- **.env**: Environment variables for the project.
- **.gitignore**: Specifies files and directories to be ignored by Git.
- **generate_verilog_codes.py**: Python script to generate Verilog codes.
- **LICENSE**: License information for the project.
- **README.md**: This file, providing an overview of the project.
- **tasks/**: Directory containing task files.
- **outputs/**: Directory containing output files.

## Setup

1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/Verilog_Codes.git
    cd Verilog_Codes
    ```

2. **Install dependencies**:
    ```sh
    pip install -r requirements.txt
    ```

3. **Create a `.env` file**:
    ```sh
    echo "OLLAMA_API_URL=http://localhost:11434" > .env
    ```

## Usage

1. **Generate tasks and save them**:
    ```sh
    python generate_verilog_codes.py
    ```

2. **Generate reports for the saved task files**:
    ```sh
    python generate_verilog_codes.py
    ```

## Contributing

Contributions are welcome! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the terms specified in the `LICENSE` file.