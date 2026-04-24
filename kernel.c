// 1. Заглушка для линковщика Windows (чтобы не просил __main)
void __main() {}

// 2. Печать текста (должна быть выше, чем её вызов)
void print_string(char* str, int row) {
    char* video_memory = (char*) 0xb8000;
    int offset = row * 80 * 2;
    for (int i = 0; str[i] != '\0'; i++) {
        video_memory[offset + i * 2] = str[i];
        video_memory[offset + i * 2 + 1] = 0x0f; // Белый цвет на черном фоне
    }
}

// 3. Главная точка входа
void _start_os() {
    // Чистим старую строку и пишем приветствие
    print_string("IDLEOS - SYSTEM READY", 0);
    print_string("Welcome, Maxim!", 1);
    
    // Бесконечный цикл, чтобы ОС не вылетела
    while(1) {
        __asm__("hlt");
    }
}