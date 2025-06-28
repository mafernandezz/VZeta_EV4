'use strict';

document.addEventListener('DOMContentLoaded', () => {
    const timeElement = document.getElementById('live-time');

    if (!timeElement) {
        console.error('Elemento con ID "live-time" no encontrado.');
        return;
    }

    const updateTime = () => {
        const now = new Date();
        const formattedTime = now.toLocaleTimeString('es-ES', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
        timeElement.textContent = formattedTime;
    };

    // Actualiza la hora inmediatamente al cargar
    updateTime();

    // Y luego actualiza cada segundo
    setInterval(updateTime, 1000);
});