function IsPhoneValid(phone) {
        const phoneRegex = /^01[016789]\d{7,8}$/;
        return phoneRegex.test(phone);
}