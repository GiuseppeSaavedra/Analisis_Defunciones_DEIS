def tasa_mortalidad_especifica(defunciones_varones,poblacion_total_varones,defunciones_mujeres,poblacion_total_mujeres):
    """
    Calcula la tasa de mortalidad específica para varones y mujeres.
    
    Parámetros:
    defunciones_varones (int): Número de defunciones en varones.
    poblacion_total_varones (int): Población total de varones.
    defunciones_mujeres (int): Número de defunciones en mujeres.
    poblacion_total_mujeres (int): Población total de mujeres.

    Retorna:
    dict: Un diccionario con las tasas de mortalidad específicas para varones y mujeres.
    """
    tasa_varones = (defunciones_varones / poblacion_total_varones) * 100000 if poblacion_total_varones > 0 else 0
    tasa_mujeres = (defunciones_mujeres / poblacion_total_mujeres) * 100000 if poblacion_total_mujeres > 0 else 0

    return {
        'tasa_mortalidad_varones': tasa_varones,
        'tasa_mortalidad_mujeres': tasa_mujeres
    }


def riesgo_relativo(tasa_varones, tasa_mujeres):
    """
    Calcula el riesgo relativo entre varones y mujeres.
    Parámetros:
    tasa_varones (float): Tasa de mortalidad específica para varones.
    tasa_mujeres (float): Tasa de mortalidad específica para mujeres.
    Retorna:
    float: El riesgo relativo (tasa_varones / tasa_mujeres).
    """

    if tasa_mujeres == 0:
        return float('No es posible dividir por cero')
    return tasa_varones / tasa_mujeres


def_varones_2024 = 217
pob_varones_2024 = 1750000
def_mujeres_2024 = 112
pob_mujeres_2024 = 1690000



tasas_2024 = tasa_mortalidad_especifica(def_varones_2024, pob_varones_2024, def_mujeres_2024, pob_mujeres_2024)
print(f"Tasa de mortalidad específica en 2024 - Varones: {tasas_2024['tasa_mortalidad_varones']:.2f} por 100000 habitantes")
print(f"Tasa de mortalidad específica en 2024 - Mujeres: {tasas_2024['tasa_mortalidad_mujeres']:.2f} por 100000 habitantes")

print(f"Riesgo relativo (Varones/Mujeres) en 2024: {riesgo_relativo(tasas_2024['tasa_mortalidad_varones'], tasas_2024['tasa_mortalidad_mujeres']):.2f}")
print(f"Este resultado nos permite confirmar la hipótesis de que los varones tienen un mayor riesgo de mortalidad específica en comparación con las mujeres en el año 2024.")
print(f"Específicamente, un varon menor de 14 años tiene un {round(((riesgo_relativo(tasas_2024['tasa_mortalidad_varones'], tasas_2024['tasa_mortalidad_mujeres']))-1)*100,2)}% de probabilidad mayor de morir en comparación con una mujer menor de la misma edad.")

