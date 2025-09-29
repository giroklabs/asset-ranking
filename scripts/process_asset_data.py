#!/usr/bin/env python3
"""
자산 데이터를 처리하고 최종 JSON 파일을 생성하는 스크립트
"""

import json
import os
from typing import Dict, Any, List

def load_existing_data() -> Dict[str, Any]:
    """기존 데이터 로드"""
    try:
        with open('data/asset-distribution.json', 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        # 기본 데이터 구조
        return {
            "lastUpdated": "2024-12-29",
            "dataSource": "한국은행 ECOS API",
            "version": "1.0.0",
            "statistics": {
                "totalPopulation": 52000000,
                "averageNetWorth": 65000000,
                "medianNetWorth": 45000000,
                "averageDebt": 45000000,
                "averageAssets": 180000000
            },
            "percentiles": {
                "0.01": 1000000000,
                "0.05": 500000000,
                "0.10": 300000000,
                "0.25": 150000000,
                "0.50": 80000000,
                "0.75": 40000000,
                "0.90": 20000000,
                "0.95": 10000000,
                "0.99": 5000000
            },
            "monthlyData": [],
            "fallback": {
                "enabled": True,
                "message": "GitHub 데이터 로드 실패 시 한국은행 API 사용"
            }
        }

def load_bok_data() -> Dict[str, Any]:
    """한국은행 API 데이터 로드"""
    try:
        with open('temp_bok_data.json', 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        return {}

def calculate_statistics(monthly_data: List[Dict[str, Any]]) -> Dict[str, Any]:
    """월별 데이터로부터 통계 계산"""
    if not monthly_data:
        return {
            "totalPopulation": 52000000,
            "averageNetWorth": 65000000,
            "medianNetWorth": 45000000,
            "averageDebt": 45000000,
            "averageAssets": 180000000
        }
    
    # 최신 월 데이터 사용
    latest_month = monthly_data[-1]
    
    avg_debt = latest_month.get('averageDebt', 45000000)
    avg_assets = latest_month.get('averageAssets', 180000000)
    net_worth = latest_month.get('netWorth', 135000000)
    
    return {
        "totalPopulation": 52000000,
        "averageNetWorth": net_worth,
        "medianNetWorth": int(net_worth * 0.7),  # 중간값은 평균의 70%
        "averageDebt": avg_debt,
        "averageAssets": avg_assets
    }

def calculate_percentiles(statistics: Dict[str, Any]) -> Dict[str, int]:
    """통계 데이터로부터 백분위 계산"""
    avg_net_worth = statistics['averageNetWorth']
    
    # 평균 순자산을 기반으로 백분위 계산
    return {
        "0.01": int(avg_net_worth * 15.0),  # 상위 1%
        "0.05": int(avg_net_worth * 8.0),   # 상위 5%
        "0.10": int(avg_net_worth * 5.0),   # 상위 10%
        "0.25": int(avg_net_worth * 2.5),   # 상위 25%
        "0.50": int(avg_net_worth * 1.2),   # 상위 50%
        "0.75": int(avg_net_worth * 0.6),   # 상위 75%
        "0.90": int(avg_net_worth * 0.3),   # 상위 90%
        "0.95": int(avg_net_worth * 0.15),  # 상위 95%
        "0.99": int(avg_net_worth * 0.05)   # 상위 99%
    }

def process_asset_data():
    """자산 데이터 처리 메인 함수"""
    print("🔄 자산 데이터 처리 시작")
    
    # 기존 데이터 로드
    existing_data = load_existing_data()
    
    # 한국은행 API 데이터 로드
    bok_data = load_bok_data()
    
    if bok_data and 'monthlyData' in bok_data:
        print(f"✅ 한국은행 데이터 로드: {len(bok_data['monthlyData'])}개 월별 데이터")
        
        # 월별 데이터 업데이트 (최근 12개월만 유지)
        monthly_data = bok_data['monthlyData'][-12:]
        
        # 통계 계산
        statistics = calculate_statistics(monthly_data)
        
        # 백분위 계산
        percentiles = calculate_percentiles(statistics)
        
        # 데이터 업데이트
        existing_data.update({
            "lastUpdated": bok_data.get('lastUpdated', existing_data['lastUpdated']),
            "statistics": statistics,
            "percentiles": percentiles,
            "monthlyData": monthly_data
        })
        
        print(f"📊 평균 순자산: {statistics['averageNetWorth']:,}원")
        print(f"📊 중간값 순자산: {statistics['medianNetWorth']:,}원")
        print(f"📊 평균 부채: {statistics['averageDebt']:,}원")
        
    else:
        print("⚠️ 한국은행 데이터 없음, 기존 데이터 유지")
    
    # 최종 데이터 저장
    os.makedirs('data', exist_ok=True)
    with open('data/asset-distribution.json', 'w', encoding='utf-8') as f:
        json.dump(existing_data, f, ensure_ascii=False, indent=2)
    
    print("✅ 자산 분포 데이터 업데이트 완료")
    
    # 임시 파일 정리
    if os.path.exists('temp_bok_data.json'):
        os.remove('temp_bok_data.json')

if __name__ == "__main__":
    process_asset_data()
