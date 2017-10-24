FROM python

VOLUME /root

ARG PROJECT_NAME

ENV GUNICORN_PROJECT ${PROJECT_NAME}.wsgi:application

WORKDIR /root

ADD ./application/requirements.txt /requirements.txt

RUN pip install -r /requirements.txt

EXPOSE 80

CMD gunicorn --bind 0.0.0.0:80 --reload ${GUNICORN_PROJECT}
