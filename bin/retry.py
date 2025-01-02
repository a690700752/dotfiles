#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time
import logging
from functools import wraps
from typing import Type, Union, Tuple, Callable

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def retry(
    max_tries: int = 3,
    delay: float = 1.0,
    backoff: float = 2.0,
    exceptions: Union[Type[Exception], Tuple[Type[Exception], ...]] = Exception,
):
    """
    重试装饰器，在函数执行失败时自动重试

    参数:
        max_tries: 最大重试次数（包含第一次尝试）
        delay: 初始重试延迟时间（秒）
        backoff: 重试延迟时间的增长倍数
        exceptions: 需要重试的异常类型，可以是单个异常类型或异常类型元组

    示例:
        @retry(max_tries=3, delay=1, backoff=2, exceptions=(ValueError, TypeError))
        def my_function():
            # 你的代码
            pass
    """

    def decorator(func: Callable):
        @wraps(func)
        def wrapper(*args, **kwargs):
            _tries, _delay = max_tries, delay
            while _tries > 0:
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    _tries -= 1
                    if _tries == 0:
                        logger.error(
                            f"函数 {func.__name__} 已达到最大重试次数 {max_tries}，最后一次错误: {str(e)}"
                        )
                        raise

                    logger.warning(
                        f"函数 {func.__name__} 执行失败 (还剩 {_tries} 次重试机会): {str(e)}"
                    )

                    time.sleep(_delay)
                    _delay *= backoff
            return None

        return wrapper

    return decorator
