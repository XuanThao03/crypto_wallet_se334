from flask import Flask, request
from dotenv import load_dotenv
from moralis import evm_api
from moralis import sol_api
import json
import os

load_dotenv()

app = Flask(__name__)
api_key = os.getenv("MORALIS_API_KEY")


@app.route("/get_token_balance", methods=["GET"])
def get_tokens():
    chain = request.args.get("chain")
    address = request.args.get("address")

    params = {
        "address": address,
        "chain": chain,
    }
    result = evm_api.balance.get_native_balance(
        api_key=api_key,
        params=params,
    )

    return result


@app.route("/get_user_nfts", methods=["GET"])
def get_nfts():
    address = request.args.get("address")
    chain = request.args.get("chain")
    params = {
        "address": address,
        "chain": chain,
        "format": "decimal",
        "limit": 100,
        "token_addresses": [],
        "cursor": "",
        "normalizeMetadata": True,
    }

    result = evm_api.nft.get_wallet_nfts(
        api_key=api_key,
        params=params,
    )

    # converting it to json because of unicode characters
    response = json.dumps(result, indent=4)
    print(response)
    return response


@app.route("/get_erc_balance", methods=["GET"])
def get_erc_token():
    chain = request.args.get("chain")
    address = request.args.get("address")

    params = {
        "address": address,
        "chain": chain,
    }
    result = evm_api.token.get_wallet_token_balances(
        api_key=api_key,
        params=params,
    )

    # converting it to json because of unicode characters
    print(result)
    return result

@app.route("/get_native_transaction", methods=["GET"])
def get_native_transaction():
    address = request.args.get("address")
    chain = request.args.get("chain")

    params = {
        "address": address,
        "chain": chain,

    }
    result =evm_api.transaction.get_wallet_transactions(
        api_key=api_key,
        params=params,
    )

    # converting it to json because of unicode characters
    print(result)
    return result

@app.route("/get_erc_transaction", methods=["GET"])
def get_erc_transaction():
    address = request.args.get("address")
    chain = request.args.get("chain")

    params = {
        "address": address,
        "chain": chain,

    }
    result =  evm_api.token.get_wallet_token_transfers(
        api_key=api_key,
        params=params,
    )

    # converting it to json because of unicode characters
    print(result)
    return result

@app.route("/get_decode_transaction", methods=["GET"])
def get_decode_transaction():
    address = request.args.get("address")
    chain = request.args.get("chain")

    params = {
        "address": address,
        "chain": chain,

    }
    result = evm_api.transaction.get_wallet_transactions_verbose(
        api_key=api_key,
        params=params,
    )

    # converting it to json because of unicode characters
    print(result)
    return result


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002, debug=True)