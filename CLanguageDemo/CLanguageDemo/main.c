//
//  main.c
//  CLanguageDemo
//
//  Created by tsaievan on 22/12/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#include <stdio.h>
#include <inttypes.h>
#include <string.h> ///< 提供strlen()函数的原型
#include <limits.h>

void demo1(void); ///< 声明的时候void要写, 不然有警告
void demo2(void);
void demo3(void);
void demo4(void);
void demo5(void);
void demo6(void);
void demo7(void);
void demo8(void);
void demo9(void);
void demo10(void);
void demo11(void);
void demo12(void);
void demo13(void);


int main() { ///< 中间的参数可以不写!
//    int num;
//    num = 1;
//    printf("I am a simple ");
//    printf("computer.\n");
//    printf("My favorite number is %d because it is first.\n", num);
//    return 0;
//    demo1();
//    demo2();
//    demo3();
//    printf("int = %lu\n", sizeof(int));
//    printf("long = %lu\n", sizeof(long));
//    printf("short = %lu\n", sizeof(short));
//    printf("long long = %lu\n", sizeof(long long));
//    printf("unsigned int  = %lu\n", sizeof(unsigned int));
//    printf("unsigned long  = %lu\n", sizeof(unsigned long));
//    printf("unsigned short  = %lu\n", sizeof(unsigned short));
//    printf("unsigned long long   = %lu\n", sizeof(unsigned long long ));
    
//    demo4();
//    demo5();
    ///< char 占一个字节
//    printf("char = %lu\n", sizeof(char));
//    demo6();
//    demo7();
//    demo8();
//    demo9();
//    demo10();
//    demo11();
//    demo12();
    demo13();
    
    return 0;
}

void demo1() {
    int feet, fathoms;
    fathoms = 2;
    feet = 6 * fathoms;
    printf("There are %d feet in %d fathoms!\n", feet, fathoms);
    printf("YES, I said %d feet!\n", 6 * fathoms);
}


void demo2() {
    float weight; // 你的体重
    float value; // 相等重量的白金价值
    
    printf("Are you worth your weight in platinum?\n");
    printf("Let's check it out.\n");
    printf("Please enter your weight in pounds: ");
    ///< 获取用户的输入
    getchar();
    getchar();
    scanf("%f", &weight);
    ///< 假设白金的价格是每盎司 $ 1700
    ///< 14.5833用于把英镑常衡盎司转换成金衡盎司
    value = 1700.0 * weight * 14.5833;
    
    printf("your weight in platinum is worth $%.2f.\n", value);
    printf("you are easily worth that! If platinum prices drop,\n");
    printf("Eat more to maintain your value.\n");
}

void demo3() {
    int x = 100;
    printf("dec = %d, octal = %o, hex = %x\n", x, x, x);
    printf("dec = %d, octal = %#o, hex = %#x\n", x, x, x);
}

///< 整数溢出
void demo4() {
    int i = 2147483647;
    unsigned int j = 4294967295;
    printf("%d %d %d\n", i, i + 1, i + 2);
    printf("%u %u %u\n", j, j + 1, j + 2);
}

///< 更多printf特性
void demo5() {
    unsigned int un = 3000000000;
    short end = 200;
    long big = 65537;
    long long veryBig = 12345678908642;
    
    printf("un = %u and not %d\n", un, un);
    printf("end = %hd and not %d\n", end, end);
    printf("big = %ld and not %hd\n", big, big);
    printf("veryBig = %lld and not %ld\n", veryBig, veryBig);
}

void demo6() {
    char ch;
    printf("Please enter a character: \n");
    scanf("%c", &ch);
    printf("The code for %c is %d.\n", ch, ch);
}

void demo7() {
    int32_t me32;
    me32 = 45933945;
    
    printf("First, assume int32_t is int: ");
    printf("me32 = %d\n", me32);
    printf("Next, let's not make any assumptions.\n");
    printf("Instead, use a \"marco\" from inttypes.h: ");
    printf("me32 = %" PRId32 "\n", me32);
}

void demo8() {
    float about = 32000.0;
    double abet = 2.14e9;
    long double dip = 5.32e-5;
    
    printf("%f can be written %e\n", about, about);
    printf("And it's %a in hexadecimal, powers of 2 notation \n", about);
    printf("%f can be written %e\n", abet, abet);
    printf("%Lf can be written %Le\n", dip, dip);
}

#define DENSITY 62.4 ///< 人体密度(单位 : 磅/立方英尺)

void demo9() {
    float weight, volume;
    int size;
    unsigned long letters;
    char name[40]; ///< name是一个可容纳40个字符的数组
    
    printf("Hi! What is your first name?\n");
    scanf("%s", name);
    printf("%s, What is your weight in pounds ?\n", name);
    scanf("%f", &weight);
    size = sizeof name;
    letters = strlen(name);
    volume = weight / DENSITY;
    printf("Well, %s, your volume is %2.2f cubic feet.\n", name, volume);
    printf("Also, your first name has %lu letters,\n", letters);
    printf("and we have %d bytes to store it.\n", size);
}
#define PRAISE  "You are an extraordinary being."
void demo10() {
    char name[40];
    printf("What is your name?\n");
    scanf("%s", name);
    printf("Hello, %s. %s\n", name, PRAISE);
    printf("your name of %zd letters occupies %zd memory cells.\n", strlen(name), sizeof name);
    printf("The phrase of praise has %zd letters", strlen(PRAISE));
    printf(" and occupies %zd memory cells.\n", sizeof PRAISE);
}

#define PI 3.141593
void demo11() {
    float area, circum, radius;
    printf("What is the radius of your pizza.\n");
    scanf("%f", &radius);
    area = PI * radius * radius;
    circum = 2 * PI * radius;
    printf("Your basic pizza parameters are as follows:\n");
    printf("circumfrence = %1.2f, area = %1.2f\n", circum, area);
}

void demo12() {
    printf("%d\n", CHAR_BIT);
    printf("%d\n", CHAR_MAX);
}

void demo13() {
    int num = 7;
    float pies = 12.75;
    int cost = 7800;
    printf("The %d contestants ate %f berry pies.\n", num, pies);
    printf("The value pf pi is %f.\n", PI);
    printf("Farewell! thou art too dear for my prossessing,\n");
    printf("%c%d\n", '$', 2 * cost);
}

