FROM ubuntu:20.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and MPI
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    libfftw3-dev \
    libblas-dev \
    liblapack-dev \
    libxc-dev \
    gfortran \
    mpich \
    libmpich-dev \
    libx11-dev \
    mpich \
    jq \
    python3.8 \
    python3.8-distutils \
    awscli \
    unzip \
    groff \
    less
   
# Set environment variables
ENV QE_HOME /opt/qe
ENV AWS_S3_BUCKET diamond-deborah
ENV AWS_REGION us-east-1         

# Download and install Quantum ESPRESSO
WORKDIR /opt
RUN wget https://www.quantum-espresso.org/rdm-download/488/v6-8/cf1cbd7b9f3eec3283f24fe827fee991/qe-6.8-ReleasePack.tgz && \
    tar -xzvf qe-6.8-ReleasePack.tgz && \
    rm qe-6.8-ReleasePack.tgz && \
    cd qe-6.8 && \
    ./configure && \
    make && \
    make pw

# Set the working directory
WORKDIR /workdir

# Copy the Quantum ESPRESSO input file into the container
# Change input and pseudopotential as your need
COPY diamond.in .
COPY Nb.pbe-nsp-van.UPF /opt/qe-6.8/pseudo/
COPY O.pbe-rrkjus.UPF /opt/qe-6.8/pseudo/
COPY Ti.pbe-sp-van_ak.UPF /opt/qe-6.8/pseudo/
COPY Y.pbe-nsp-van.UPF /opt/qe-6.8/pseudo/


# Set the PATH variable to include the directory where pw.x is installed
ENV PATH="/opt/qe-6.8/bin:${PATH}"

# Set up MPI environment variables
ENV OMP_NUM_THREADS=1
ENV MKL_NUM_THREADS=1
ENV MPICH_MAX_THREAD_SAFETY=multiple

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]