import pandas as pd

#Leemos los datos y almacenamos una ruta
csv_final_defunciones = "C:/Users/gmarc/OneDrive/Desktop/Python/final_defunciones_oracle2.csv"
df = pd.read_csv('C:/Users/gmarc/OneDrive/Desktop/Python/DEFUNCIONES_FUENTE_DEIS_2023_2025_14102025.csv',encoding='latin-1',sep=";") 

#Agregamos id a la región para hacer más facil la implementación de tablas con llaves foráneas 
region_to_id = {region: i + 1 for i, region in enumerate(df["NOMBRE_REGION"].unique())}
df['COD_REGION'] = df['NOMBRE_REGION'].map(region_to_id)

#Exportamos el archivo final
df.to_csv(csv_final_defunciones, index=False, encoding="utf-8-sig",sep=";")

print(df)