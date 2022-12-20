### To do:  


Refactor latent space functions. 
Struct latent graph:
- Complete distance matrix (n * n )  
- Complete weighted graph  
- Prunned graph (e.g. naive graph removes duplicates in recurrences)  
- Prunned weighted graph from prunned graph  

---
Version of latent_space_graph with
Distance to topic. e.g: latent_distances(text,topic_word, corpus)
get_embeddings(speech_transcript,"cachorro",emb_table)

---

Recurrence based on string distances

---

Find a transformation for centrality and connectivity that scales linearly with length of graph.
For det(X), log(det(x)) worked.

---

Add multiple edges for repeated recurrences. 

---

Remove stopwords when analyzing semantic distances.
