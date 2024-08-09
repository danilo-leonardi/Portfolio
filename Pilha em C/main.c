#include <stdio.h>
#include <stdlib.h>

typedef struct no{
    float info;
    struct no *prox;
}no;

typedef struct pilha{
    no *topo;
}pilha;

pilha* cria(){
    pilha *p = (pilha*) malloc(sizeof(pilha));
    p->topo = NULL;
    return p;
}

int vazia(pilha *p){
    return (p->topo==NULL);
}

void push (pilha* p, float dado){
    no *novo = (no*) malloc(sizeof(no));
    novo->info = dado;
    novo->prox = p->topo;
    p->topo = novo;
}

float pop (pilha* p){
    if (vazia(p)) {
        printf("Pilha vazia.\n");
        exit(1);
    }
    float temp = p->topo->info;
    no *aux = p->topo;
    p->topo=aux->prox;
    free(aux);
    return temp;
}
void imprime (pilha* p){
    no *aux;
    for (aux=p->topo; aux!=NULL; aux=aux->prox)
        printf("%2.f\n",aux->info);
}
void libera (pilha* p){
    no *aux = p->topo;
    while (aux!=NULL) {
        no *temp = aux->prox;
        free(aux);
        aux = temp;
    }
    free(p);
}

int main() {
    pilha *p1=cria();    
   push(p1,3);
   push(p1,5);
   push(p1,2);
   push(p1,7);
   imprime(p1);
   printf("Removeu %2.f\n",pop(p1));
   printf("Removeu %2.f\n",pop(p1));
   printf("Removeu %2.f\n",pop(p1));
   imprime(p1);
   libera(p1);
    return 0;
}
