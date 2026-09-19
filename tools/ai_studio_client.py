"""
Google AI Studio (Gemini) Client Tool for Bol Gol Futbol
Allows generating game commentaries, dynamic dialogues, localized text, and gameplay balance analysis.
"""
import os
import sys
import json
import urllib.request
import urllib.error
import argparse

API_KEY = os.environ.get("GEMINI_API_KEY", "")

def generate_content(prompt: str, model: str = "gemini-2.5-flash", system_instruction: str = ""):
    api_key = os.environ.get("GEMINI_API_KEY", API_KEY)
    if not api_key:
        print("[AI Studio Error] GEMINI_API_KEY environment variable is not set.")
        print("Set it using: [System.Environment]::SetEnvironmentVariable('GEMINI_API_KEY', 'your_key_here', 'User')")
        return None

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    
    payload = {
        "contents": [
            {
                "parts": [
                    {"text": prompt}
                ]
            }
        ]
    }
    
    if system_instruction:
        payload["systemInstruction"] = {
            "parts": [{"text": system_instruction}]
        }

    headers = {"Content-Type": "application/json"}
    req = urllib.request.Request(url, data=json.dumps(payload).encode("utf-8"), headers=headers, method="POST")

    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            candidates = data.get("candidates", [])
            if candidates:
                content_parts = candidates[0].get("content", {}).get("parts", [])
                text = "".join([p.get("text", "") for p in content_parts])
                return text
            return ""
    except urllib.error.HTTPError as e:
        err_msg = e.read().decode("utf-8")
        print(f"[AI Studio HTTP Error {e.code}]: {err_msg}")
        return None
    except Exception as e:
        print(f"[AI Studio Error]: {e}")
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Google AI Studio Gemini Client")
    parser.add_argument("--prompt", type=str, required=True, help="Prompt to send to Gemini")
    parser.add_argument("--model", type=str, default="gemini-2.5-flash", help="Gemini model")
    parser.add_argument("--system", type=str, default="", help="System instruction")
    args = parser.parse_args()

    result = generate_content(args.prompt, model=args.model, system_instruction=args.system)
    if result is not None:
        print("--- Gemini Response ---")
        print(result)
