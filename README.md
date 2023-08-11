# Visual-Search-of-an-Image-Collection
Visual Search of an Image Collection using the Microsoft Research (MSVC-v2) dataset of 591 images (20 classes)

The primary requirement of this project is to perform visual search of an image collection. The image collection to be used is the Microsoft Research (MSVC-v2) dataset of 591 images (20 classes) available for download at the link:
http://download.microsoft.com/download/3/3/9/339D8A24-47D7-412F-A1E8-1A415BC48A15/msrc_objcategimagedatabase_v2.zip
The images are of 20 different classes namely Grassy Farmlands, Trees, Buildings, Aeroplanes, Cows, Human Faces, Cars, Bicycles, Sheep, Flowers, Sign Boards, Birds, Books, Chairs, Cats, Dogs, Streets, Water Bodies, People and Shores.
To be able to search the image dataset, first an image descriptor should be created for each image in the dataset, and then the descriptor of the query image is matched with each of the descriptors and the results are ranked based on similarity. Top 20 ranked images are selected to evaluate the correctness of the search technique used.
