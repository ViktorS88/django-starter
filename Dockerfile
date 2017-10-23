FROM python

VOLUME /root

ARG project_name

WORKDIR /root

ADD ./application/requirements.txt /requirements.txt

RUN pip install -r /requirements.txt

EXPOSE 80

CMD gunicorn --bind 0.0.0.0:80 --reload $project_name.wsgi:application
