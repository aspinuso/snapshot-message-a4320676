FROM registry.gitlab.com/knmi-oss/swirrl/jupyterswirrlui/icclim-jupyter-notebook:a7937c9f
USER root
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}
RUN id ${NB_USER} || adduser --disabled-password --gecos "Default user" --uid ${NB_UID} ${NB_USER}
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
WORKDIR ${HOME}
