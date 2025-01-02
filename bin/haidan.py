#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import requests
import dingding
from dataclasses import dataclass
from typing import Optional, Tuple, Dict
from retry import retry


@dataclass
class HaiDanConfig:
    base_url: str = "https://www.haidan.video/index.php"
    sign_url: str = "https://www.haidan.video/signin.php"
    privacy: str = "1"
    headers: Dict[str, str] = None

    @classmethod
    def from_env(cls) -> "HaiDanConfig":
        privacy = os.getenv("HAIDAN_PRIVACY", "1")
        _login = os.getenv("HAIDAN_LOGIN", "bm9wZQ%3D%3D")
        _ssl = os.getenv("HAIDAN_SSL", "eWVhaA%3D%3D")
        _tracker_ssl = os.getenv("HAIDAN_TRACKER_SSL", "eWVhaA%3D%3D")

        return cls(
            privacy=privacy,
            headers={
                "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
            },
        )

    def update_headers(self, uid: str, password: str) -> None:
        _login = os.getenv("HAIDAN_LOGIN", "bm9wZQ%3D%3D")
        _ssl = os.getenv("HAIDAN_SSL", "eWVhaA%3D%3D")
        _tracker_ssl = os.getenv("HAIDAN_TRACKER_SSL", "eWVhaA%3D%3D")

        self.headers.update(
            {
                "cookie": f"c_secure_login={_login}; c_secure_uid={uid}; "
                f"c_secure_pass={password}; c_secure_tracker_ssl={_tracker_ssl}; "
                f"c_secure_ssl={_ssl}"
            }
        )


class HaiDan:
    def __init__(self, config: HaiDanConfig):
        self.config = config
        self.error = 0

    def sign(self, current_magic: float) -> Tuple[int, Optional[float]]:
        """Sign in and return new magic number difference"""
        r = requests.get(self.config.sign_url, headers=self.config.headers)
        if r.status_code != 200:
            print("!! 签到失败，错误的状态： " + str(r.status_code))
            return 1, None

        print("-> 尝试更新魔力值")
        r = requests.get(self.config.base_url, headers=self.config.headers)
        if r.status_code != 200:
            print("!! 错误的状态： " + str(r.status_code))
            return 1, None

        pattern = re.compile(
            r"<span\s*id=['|\"]magic_num['|\"]>([0-9,\.]+)\([\s\S]+\)</span>"
        )
        mn = re.search(pattern, r.text)

        if mn:
            new_magic = float(mn.group(1).replace(",", ""))
            magic_diff = new_magic - current_magic
            print("-> 签到成功，获得魔力值：" + str(magic_diff))
            return 0, magic_diff
        else:
            print("!! 获取最新魔力值失败")
            return 3, None

    def get_status(self) -> Tuple[int, Optional[float]]:
        """Get user status and magic number"""
        print("-> 正在获取用户状态...")
        r = requests.get(self.config.base_url, headers=self.config.headers)
        if r.status_code != 200:
            print("!! 错误的状态： " + str(r.status_code))
            return 1, None

        # Check username
        pattern = re.compile(
            r"<a\s*href=['|\"]userdetails\.php\?id=\d+['|\"]\s*class=['|\"].+['|\"]\s*>\s*<b>\s*(.+)</b>\s*</a>"
        )
        username = re.search(pattern, r.text)
        if username:
            if self.config.privacy == "2":
                print("-> 当前用户：[保护]")
            elif self.config.privacy == "3":
                print("-> 当前用户：" + username.group(1))
            else:
                if self.config.privacy != "1":
                    print("!! 错误的隐私登录设置")
                print(
                    "-> 当前用户：*"
                    + username.group(1)[1 : len(username.group(1)) - 1]
                    + "*"
                )
        else:
            print("-> 登录身份过期或程序失效")
            return 2, None

        # Get magic number
        pattern = re.compile(
            r"<span\s*id=['|\"]magic_num['|\"]>([0-9,\.]+)\([\s\S]+\)</span>"
        )
        mn = re.search(pattern, r.text)
        if not mn:
            print("-> 登录身份过期或程序失效")
            return 2, None

        magic_num = float(mn.group(1).replace(",", ""))
        print("-> 当前魔力值：" + str(magic_num))

        # Check sign status
        pattern = re.compile(
            r"<input\s*type=['|\"]submit['|\"]\s*id=['|\"]modalBtn['|\"]\s*class=['|\"]dt_button['|\"]\s*value=['|\"]已经打卡['|\"][\s]*/[\s]*>"
        )
        signed = re.search(pattern, r.text)

        if not signed:
            return self.sign(magic_num)
        else:
            print("-> 今日已签到")
            return 0, None


@dingding.notify_dingding
@retry()
def main() -> int:
    print("=================================================")
    print("||                 HaiDan Sign                 ||")
    print("||                Author: Jokin                ||")
    print("||               Version: v0.0.6               ||")
    print("=================================================")

    config = HaiDanConfig.from_env()

    _uid = os.getenv("HAIDAN_UID")
    _pass = os.getenv("HAIDAN_PASS")
    _multi = os.getenv("HAIDAN_MULTI")

    if not _multi:
        if not _uid or not _pass:
            print("!! 缺少设置： 环境变量/Secrets")
            raise ValueError("!! 缺少设置： 环境变量/Secrets")
        _multi = f"{_uid}@{_pass}"
    else:
        print("-> 多账户支持已经启用")

    # Process multiple accounts
    accounts = [acc.strip().split("@") for acc in _multi.split(",")]
    if any(len(acc) != 2 for acc in accounts):
        print("!! 多账户设置格式错误")
        raise ValueError("!! 多账户设置格式错误")

    error = 0
    for i, (uid, password) in enumerate(accounts, 1):
        print(f"-> 当前进度： {i}/{len(accounts)}")
        config.update_headers(uid, password)
        haidan = HaiDan(config)
        current_error, _ = haidan.get_status()
        error = current_error if current_error else error

    print("-> 已经完成本次任务")
    if error != 0:
        print("!! 本次任务出现错误，请及时查看日志")
        raise ValueError("!! 本次任务出现错误，请及时查看日志")
    else:
        print("-> 任务圆满完成")


if __name__ == "__main__":
    exit(main())
