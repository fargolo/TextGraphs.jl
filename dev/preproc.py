from json.tool import main
from multiprocessing.spawn import _main
import spacy

class Preproc:
    '''This class implements some of the preprocess functions necessary to create vertices
        and edges on TextGraphs'''
    def __init__(self, lang = 'ptbr', lib = 'spacy', **kwargs) -> None:
        '''
        Preproc object constructor
        :param lang: string, language to be used (default: ptbr)
        :param lib: string, library to be used (default: spaCy)
        :param kwargs: other dict-like args
            :kwargs.spacymodel: model to be used with spaCy (default: pt_core_news_lg)
        '''
        self.kwargs = kwargs
        self.lang = lang
        self.lib = lib
        self.nlp = None
        self.implementedLibs = ['spacy']

        # loading spacy with selected language and model
        self.loadModel()

    def loadModel(self):
        '''Function to load lib and model'''
        print('[INFO]: Loading model.')
        if self.lib == 'spacy':
            if self.lang == 'ptbr':
                self.nlp = spacy.load(self.kwargs.get('spacymodel')) if self.kwargs.get('spacymodel') is not None \
                                                  else spacy.load('pt_core_news_lg')
                print('[INFO]: Language model loaded.')
            else:
                print(f'[WARNING]: Language {self.lang} not yet implemented.')  
        elif self.lib == 'nltk':
           print(f'[WARNING]: NLTK not yet implemented, please use \
                                one of the following libs \
                                {self.implementedLibs}')    
        else:
            print(f'[WARNING]: The lib you tried to load is not implemented yet, \
                                please use one of the following libs \
                                {self.implementedLibs}')
    
    def doPOSprec(self, text):
        '''This function does the POS preprocessing
        :param text: string, text to be preprocessed
        :return: python-list with each token from the input text represented as its predicted POS
        '''
        assert self.nlp is not None, "No language model loaded."
        assert isinstance(text, str), "f{text} is not String."
        pos_list = []
        for token in self.nlp(text):
            pos_list.append(token.pos_)
        return pos_list


def main():
    posTagger = Preproc()

    example = 'Faço de mim Casa de sentimentos bons Onde a má fé não faz morada \
               E a maldade não se cria Me cerco de boas intenções E amigos de nobres corações \
               Que sopram e abrem portões Com chave que não se copia'
    
    print(posTagger.doPOSprec(example))

if __name__ == "__main__":
    main()