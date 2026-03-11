#!/usr/bin/env python3
import imaplib
import email

# === CONFIGURACIÓN ===
USERNAME = "tu_correo@gmail.com"
PASSWORD = "tu_contraseña_de_aplicacion" # 16 caracteres si es Gmail
SERVER = "imap.gmail.com"
PORT = 993
# =====================

def check_mail():
    try:
        # Conectar al servidor IMAP
        mail = imaplib.IMAP4_SSL(SERVER, PORT)
        mail.login(USERNAME, PASSWORD)

        # Seleccionar la bandeja de entrada
        mail.select("inbox")

        # Buscar correos no leídos (UNSEEN)
        status, search_data = mail.search(None, 'UNSEEN')

        if status == 'OK':
            # Contar cuántos IDs de correo nos ha devuelto
            unread_count = len(search_data[0].split())
            print(unread_count)
        else:
            print("0")

        mail.logout()
    except Exception:
        # Si falla (sin internet, mala contraseña, etc.), saca 0 para no romper Conky
        print("0")

if __name__ == "__main__":
    check_mail()
