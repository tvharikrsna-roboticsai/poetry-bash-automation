#!/bin/bash
set -e

# 1. Create a Poetry Package
read -p "Package Name:  " pkg
poetry new "$pkg" && cd "$pkg"

echo

# 2. Adding Dependencies
read -p "Add Dev Deps? [y/n]:   " DDR
if [[ "$DDR" == "y" ]]; then
    read -p "Name(s):  " DD
    poetry add --group dev $DD
    DD_LIST=($DD)
fi

echo

# 3. TOML File Configuration Writer
for dep in "${DD_LIST[@]}"; do
    read -p "Add Config for $dep? [y/n]:    " ANS
    if [[ "$ANS" == "y" ]]; then
        echo -e "\n[tool.$dep]" >> pyproject.toml
        while true; do
            read -p "Enter Config for $dep in key=value format (press Enter to stop):   " TOMLVALUES
            [[ -z "$TOMLVALUES" ]] && break
            echo "$TOMLVALUES" >> pyproject.toml
        done
    fi
done

echo

# 4. Adding .py Files
read -p "Add .py Files? [y/n]:  " PFR
if [[ "$PFR" == "y" ]]; then
    read -p "How many .py Files?: " PFC
    for ((i=1;i<=PFC;i++)); do
        echo " " && pwd && tree -L 1
        read -p "Enter File Path with File Name (e.g., src/main.py):  " PFPFN

        mkdir -p "$(dirname "$PFPFN")"
        cat <<'EOF' > "$PFPFN"
def fun() -> None:
    pass


if __name__ == "__main__":
    fun()
EOF

    done
fi

echo
echo "✅ Setup Complete!"