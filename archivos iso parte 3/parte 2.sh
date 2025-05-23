#!/usr/bin/env bash
#
# create_users.sh – crea usuarios en lote a partir de un CSV.
# Uso: ./create_users.sh users.csv
#

CSV_FILE="$1"
if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: archivo $CSV_FILE no encontrado."
  exit 1
fi

while IFS=, read -r username fullname password groups; do
  # Saltar cabecera
  if [[ "$username" == "username" ]]; then continue; fi

  echo "Creando usuario: $username ($fullname)…"
  useradd -m -c "$fullname" -G "$groups" "$username"
  echo "$username:$password" | chpasswd
  passwd -e "$username"  # fuerza cambio de contraseña al primer login
done < "$CSV_FILE"