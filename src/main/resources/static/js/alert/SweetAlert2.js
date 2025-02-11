function Toast(position, timer, status, title) {
    const Toast = Swal.mixin({
        toast: true,
        position: position,
        width:"400",
        showConfirmButton: false,
        timer: timer,
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer)
            toast.addEventListener('mouseleave', Swal.resumeTimer)
        }
    })

    Toast.fire({
        icon: status,
        title: title
    })
}