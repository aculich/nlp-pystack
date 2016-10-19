##########################################################################################
# Data Science PyStack toolbox:                                                          #
# - Essential set of R and Python packages from base image                               #
# - Visualization Tools: matplotlib, seaborn, altair                                     #
# - Deep Learning frameworks (TensorFlow, Keras)                                         #
# - NLP (spaCy, NLTK, gensim)                                                            #
#                                                                                        #
# 21.09.2016                                                                             #
##########################################################################################

FROM antonp84/base

MAINTAINER	"Anton Petrov" petrov.anton.k@gmail.com

# install machine learning tools
RUN apt-get update && \
	apt-get install -y python3-scipy && \
	pip3 install statsmodels && \
	pip3 install scikit-image && \
	pip3 install bokeh && \
	pip3 install altair
	# pip3 install mpld3

# install deep learning frameworks
RUN pip3 install -U https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.11.0rc0-cp35-cp35m-linux_x86_64.whl && \
	pip3 install keras

# NLP NLTK
RUN pip3 install nltk && \
	python3 -m nltk.downloader book
	
# NLP NLTK STANFORD
ENV CLASSPATH /opt/stanford-nlp/stanford-parser-full-2015-12-09:/opt/stanford-nlp/stanford-postagger-full-2015-12-09:/opt/stanford-nlp/stanford-ner-2015-12-09
ENV STANFORD_MODELS /opt/stanford-nlp/stanford-postagger-full-2015-12-09/models:/opt/stanford-nlp/stanford-ner-2015-12-09/classifiers/

RUN apt-get install -y default-jre && \
	mkdir /opt/stanford-nlp && \
	cd /opt/stanford-nlp && \
	wget --no-verbose http://nlp.stanford.edu/software/stanford-parser-full-2015-12-09.zip && \
	wget --no-verbose http://nlp.stanford.edu/software/stanford-postagger-full-2015-12-09.zip && \
	wget --no-verbose http://nlp.stanford.edu/software/stanford-ner-2015-12-09.zip && \
	unzip -q stanford-parser-full-2015-12-09.zip && \
	unzip -q stanford-postagger-full-2015-12-09.zip && \
	unzip -q stanford-ner-2015-12-09.zip && \
	rm *.zip
	
# NLP Gensim & spaCy
RUN pip3 install --upgrade gensim && \
	pip3 install spacy && \
	python3 -m spacy.en.download && \
	python3 -c "import spacy; spacy.load('en'); print('OK')"

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*	
	
VOLUME /home
EXPOSE 8888

# create jupyter notebook
CMD jupyter notebook --no-browser --port 8888 --ip=0.0.0.0 --notebook-dir=/home
