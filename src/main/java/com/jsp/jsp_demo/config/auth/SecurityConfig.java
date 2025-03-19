package com.jsp.jsp_demo.config.auth;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@EnableGlobalMethodSecurity(securedEnabled = true, prePostEnabled = true)
public class SecurityConfig {
    @Bean
    public PasswordEncoder getPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity security) throws Exception {

        security.csrf().disable()
                .headers().frameOptions().disable();

        security.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED);

        security.authorizeHttpRequests()
                .antMatchers("/css/**", "/js/**", "/images/**").permitAll()
                .antMatchers("/auth/**").permitAll()          // /auth/** 경로 허용
                .anyRequest().authenticated();               // 그 외 모든 요청은 인증 필요

        security.formLogin().disable();
        security.httpBasic().disable();

        security.exceptionHandling()
                .authenticationEntryPoint((request, response, authException) -> {
                    response.sendRedirect("/auth/login"); // 인증 실패 시 로그인 페이지로 리다이렉트
                })
                .accessDeniedHandler((request, response, accessDeniedException) -> {
                    response.sendRedirect("/auth/login"); // 권한 부족 시 로그인 페이지로 리다이렉트
                });

        return security.build();
    }
}
