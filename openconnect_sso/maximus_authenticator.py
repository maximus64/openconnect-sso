import structlog

log = structlog.get_logger()


async def authenticate_in_browser(proxy, auth_info, credentials, display_mode):
    print(f"auth_info.login_url = {auth_info.login_url}")
    # print(f"auth_info.login_final_url = {auth_info.login_final_url}")
    # print(f"credentials = {credentials}")
    # print(f"auth_info.token_cookie_name = {auth_info.token_cookie_name}")

    token_cookie = input(f'Enter {auth_info.token_cookie_name} cookie value: ')

    return token_cookie
