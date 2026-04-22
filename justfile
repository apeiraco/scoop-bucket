setup:
    mise install
    cd docs && pnpm install

dev-docs:
    cd docs && pnpm run dev

build-docs:
    cd docs && pnpm run build

preview-docs:
    cd docs && pnpm run preview
