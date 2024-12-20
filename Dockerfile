FROM ghcr.io/feelpp/feelpp:jammy


WORKDIR /workspace

COPY requirements.txt .

RUN python3 -m venv .venv && \
	. .venv/bin/activate && \
	pip install -r requirements.txt

COPY . /workspace/2024-m2-project-eye-kalman

WORKDIR /workspace/2024-m2-project-eye-kalman

CMD ["source /workspace/.venv/bin/activate"]