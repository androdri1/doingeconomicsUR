# =============================================================================
# Script: graficos_tenderos.py
# Descripción: Este script genera cuatro tipos de gráficos (barras, líneas, dispersión,
#              barras apiladas) utilizando datos de una encuesta a tenderos.
#              Cada gráfico ilustra un concepto clave de visualización de datos.
# Autor: Paul Rodriguez
# Fecha: Julio 7
# =============================================================================

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# -----------------------------------------------------------------------------
# Cargar la base de datos
# -----------------------------------------------------------------------------
df = pd.read_stata("Tenderos03_Publica.dta")

# -----------------------------------------------------------------------------
# 1. Gráfico de barras: Número de negocios por género del dueño
# -----------------------------------------------------------------------------
# Se cuenta la cantidad de negocios según el género del dueño.
# Los códigos se traducen a etiquetas legibles.
bar_data = df["Genero"].value_counts().sort_index()
bar_data.index = ["Mujer", "Hombre", "Otro/No responde"]

plt.figure(figsize=(8, 6))
bar_data.plot(kind="bar", color="skyblue")
plt.title("Número de negocios por género del dueño")
plt.xlabel("Género")
plt.ylabel("Número de negocios")
plt.tight_layout()
plt.savefig("grafico_barras_genero.png")
plt.close()

# -----------------------------------------------------------------------------
# 2. Gráfico de líneas: Ingreso mensual promedio por edad del dueño
# -----------------------------------------------------------------------------
# Se calcula el ingreso mensual promedio por cada grupo de edad.
line_data = df.groupby("Edad")["incomeMonth"].mean().dropna()

plt.figure(figsize=(10, 6))
line_data.plot()
plt.title("Ingresos mensuales promedio por edad del dueño")
plt.xlabel("Edad")
plt.ylabel("Ingreso mensual promedio")
plt.tight_layout()
plt.savefig("grafico_lineas_ingresos_edad.png")
plt.close()

# -----------------------------------------------------------------------------
# 3. Gráfico de dispersión: Ingresos vs. gastos mensuales
# -----------------------------------------------------------------------------
# Se explora la relación entre ingresos y gastos mensuales.
scatter_data = df[["incomeMonth", "expensesMonth"]].dropna()

plt.figure(figsize=(8, 6))
sns.scatterplot(data=scatter_data, x="incomeMonth", y="expensesMonth")
plt.title("Relación entre ingresos y gastos mensuales")
plt.xlabel("Ingresos mensuales")
plt.ylabel("Gastos mensuales")
plt.tight_layout()
plt.savefig("grafico_dispersion_ingresos_gastos.png")
plt.close()

# -----------------------------------------------------------------------------
# 4. Gráfico de barras apiladas: Uso de medios de pago por municipio
# -----------------------------------------------------------------------------
# Se calcula la proporción de uso de efectivo y tarjeta por municipio.
df["pago_efectivo"] = df["medios_pago__3"]  # Efectivo
df["pago_tarjeta"] = df["medios_pago__1"]   # Tarjeta crédito

stacked_data = df.groupby("Munic_Dept")[["pago_efectivo", "pago_tarjeta"]].mean()
stacked_data = stacked_data.div(stacked_data.sum(axis=1), axis=0)  # Normalizar

stacked_data.plot(kind="bar", stacked=True, figsize=(10, 6))
plt.title("Proporción de medios de pago por municipio")
plt.xlabel("Municipio (DIVIPOLA)")
plt.ylabel("Proporción (%)")
plt.legend(["Efectivo", "Tarjeta"])
plt.tight_layout()
plt.savefig("grafico_barras_apiladas_medios_pago.png")
plt.close()
