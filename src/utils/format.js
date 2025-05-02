/**
 * 格式化日期时间
 * @param {string|Date} date 日期对象或日期字符串
 * @param {string} format 格式化模板，例如：'YYYY-MM-DD HH:mm:ss'
 * @returns {string} 格式化后的日期字符串
 */
export const formatDate = (date, format = 'YYYY-MM-DD') => {
    if (!date) return '未知';

    const d = typeof date === 'string' ? new Date(date) : date;

    // 检查日期是否有效
    if (isNaN(d.getTime())) return '无效日期';

    const year = d.getFullYear();
    const month = d.getMonth() + 1;
    const day = d.getDate();
    const hours = d.getHours();
    const minutes = d.getMinutes();
    const seconds = d.getSeconds();

    // 给个位数补0
    const padZero = (num) => (num < 10 ? `0${num}` : num);

    return format
        .replace('YYYY', year)
        .replace('MM', padZero(month))
        .replace('DD', padZero(day))
        .replace('HH', padZero(hours))
        .replace('mm', padZero(minutes))
        .replace('ss', padZero(seconds));
};

/**
 * 格式化金额
 * @param {number} amount 金额
 * @param {number} decimals 小数位数
 * @param {string} currency 货币符号
 * @returns {string} 格式化后的金额
 */
export const formatAmount = (amount, decimals = 2, currency = '¥') => {
    if (typeof amount !== 'number') return '0.00';

    return `${currency}${amount.toFixed(decimals)}`;
};

/**
 * 格式化手机号 (隐藏中间4位)
 * @param {string} phone 手机号
 * @returns {string} 格式化后的手机号
 */
export const formatPhone = (phone) => {
    if (!phone || phone.length < 11) return phone;

    return `${phone.substring(0, 3)}****${phone.substring(7)}`;
};

/**
 * 格式化大数字 (例如：1000 -> 1k, 1000000 -> 1M)
 * @param {number} num 数字
 * @returns {string} 格式化后的数字
 */
export const formatLargeNumber = (num) => {
    if (typeof num !== 'number') return '0';

    if (num >= 1000000) {
        return `${(num / 1000000).toFixed(1)}M`;
    }

    if (num >= 1000) {
        return `${(num / 1000).toFixed(1)}k`;
    }

    return num.toString();
};

/**
 * 格式化百分比
 * @param {number} value 百分比值 (0-1)
 * @param {number} decimals 小数位数
 * @returns {string} 格式化后的百分比
 */
export const formatPercent = (value, decimals = 0) => {
    if (typeof value !== 'number') return '0%';

    return `${(value * 100).toFixed(decimals)}%`;
}; 